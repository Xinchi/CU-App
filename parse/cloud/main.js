
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
const CuMemberCycle = "12";

Parse.Cloud.define("activationFailResponse", function(request, response) {
  response.success("Member ID is invalid");
});

Parse.Cloud.define("activationSuccessResponse", function(request, response) {
  response.success("You have successfully activated your CU membership, thank you!");
});


Parse.Cloud.define("invalidMemberId", function(request, response) {
  response.success("Invalid Member ID Entered! No matching found!");
});

Parse.Cloud.define("signupSuccessful", function(request, response) {
  response.success("Welcome to Chinese Union! An email has been sent to you, please check the email and click on the link to verify your email address.  You can only enjoy all the features of Chinese Union App upon successfully verifying your email address!");
});

Parse.Cloud.define("loginSuccessful", function(request, response) {
  response.success("Welcome back!");
});

Parse.Cloud.define("loginFail", function(request, response) {
  response.success("Wrong username or password.  If you have linked your account with Facebook, please log in with Facebook directly");
});

Parse.Cloud.define("getTime",function(request, response) {
  response.success(new Date());
});

Parse.Cloud.define("getMembershipExpireDate", function(request, response){
  response.success(new Date("October 1, 2015 00:00:00"))
});

Parse.Cloud.define("memberShipCycle", function(request, response) {
  response.success(CuMemberCycle);
});

Parse.Cloud.define("correctEmailForResettingPassword", function(request, response) {
      response.success("An email has been sent to your mailbox for resetting password");
});

Parse.Cloud.define("incorrectEmailForResettingPassword", function(request, response) {
  response.success("Invalid email entered, please enter a valid email that you used during signup");
});



Parse.Cloud.define("uploadFBImage", function(request, response) {
  console.log('uploadFBImage running... ');
  console.log('url = ' + request.params.url);

  Parse.Cloud.httpRequest({
    url:'http://upload.wikimedia.org/wikipedia/commons/9/9a/PNG_transparency_demonstration_2.png',
    success:function(httpResponse){
      console.log('httpResponse successful');
      // var image = new Parse.File('image', httpResponse.data);
      var imageBuffer = httpResponse.buffer;
      var base64 = imageBuffer.toString('base64');
      console.log('image buffer string = '+base64);

      var imageFile = new Parse.File("image.jpg", { base64: base64 });
      // var image = new Image();
      // image.setData(httpResponse.buffer);
      // image.setFormat("PNG");
      var currentUser = Parse.User.current();
      if (currentUser) {
          // do stuff with the user
          currentUser.set("profilePic",imageFile);
          currentUser.save();
      } else {
          // show the signup or login page
      }
      response.success();
    },
    error:function(httpResponse){
      console.log('RequestFailed with response code '+httpResponse.status);
      response.error();
    }
  });
  
});





/* Initialize the Stripe and Mailgun Cloud Modules */
var Stripe = require('stripe');
Stripe.initialize('sk_test_nAt6j3GrlrxLxoYKZr7KU1zq');

var Mailgun = require('mailgun');
Mailgun.initialize("", "");

/*
 * Purchase an item from the Parse Store using the Stripe
 * Cloud Module.
 *
 * Expected input (in request.params):
 *   itemName       : String, can be "Mug, "Tshirt" or "Hoodie"
 *   size           : String, optional for items like the mug 
 *   cardToken      : String, the credit card token returned to the client from Stripe
 *   name           : String, the buyer's name
 *   email          : String, the buyer's email address
 *   address        : String, the buyer's street address
 *   city_state     : String, the buyer's city and state
 *   zip            : String, the buyer's zip code
 *
 * Also, please note that on success, "Success" will be returned. 
 */
Parse.Cloud.define("purchaseItem", function(request, response) {
  // The Item and Order tables are completely locked down. We 
  // ensure only Cloud Code can get access by using the master key.
  Parse.Cloud.useMasterKey();

  // Top level variables used in the promise chain. Unlike callbacks,
  // each link in the chain of promise has a separate context.
  var item, order;

  // We start in the context of a promise to keep all the
  // asynchronous code consistent. This is not required.
  Parse.Promise.as().then(function() {
    // Find the item to purchase.
    var itemQuery = new Parse.Query('CUProducts');
    itemQuery.equalTo('name', request.params.itemName);

    // Find the resuts. We handle the error here so our
    // handlers don't conflict when the error propagates.
    // Notice we do this for all asynchronous calls since we
    // want to handle the error differently each time.
    return itemQuery.first().then(null, function(error) {
      return Parse.Promise.error('Sorry, this item is no longer available.');
    });

  }).then(function(result) {
    // Make sure we found an item and that it's not out of stock.
    if (!result) {
      return Parse.Promise.error('Sorry, this item is no longer available.');
    } else if (result.get('quantityAvailable') <= 0) { // Cannot be 0
      return Parse.Promise.error('Sorry, this item is out of stock.');
    }

    // Decrease the quantity.
    item = result;
    item.increment('quantityAvailable', -1);

    // Save item.
    return item.save().then(null, function(error) {
      console.log('Decrementing quantity failed. Error: ' + error);
      return Parse.Promise.error('An error has occurred. Your credit card was not charged.');
    });

  }).then(function(result) {
    // Make sure a concurrent request didn't take the last item.
    item = result;
    if (item.get('quantityAvailable') < 0) { // can be 0 if we took the last
      return Parse.Promise.error('Sorry, this item is out of stock.');
    }

    // We have items left! Let's create our order item before 
    // charging the credit card (just to be safe).
    order = new Parse.Object('Order');
    order.set('name', request.params.name);
    order.set('email', request.params.email);
    order.set('address', request.params.address);
    order.set('zip', request.params.zip);
    order.set('city_state', request.params.city);
    order.set('item', item);
    order.set('product', item.get('name'));
    order.set('size', request.params.size || 'N/A');
    order.set('fulfilled', false);
    order.set('charged', false); // set to false until we actually charge the card

    // Create new order
    return order.save().then(null, function(error) {
      // This would be a good place to replenish the quantity we've removed.
      // We've ommited this step in this app.
      console.log('Creating order object failed. Error: ' + error);
      return Parse.Promise.error('An error has occurred. Your credit card was not charged.');
    });

  }).then(function(order) { 
    // Now we can charge the credit card using Stripe and the credit card token.
    return Stripe.Charges.create({
      amount: item.get('price') * 100, // express dollars in cents 
      currency: 'usd',
      card: request.params.cardToken
    }).then(null, function(error) {
      console.log('Charging with stripe failed. Error: ' + error);
      return Parse.Promise.error('An error has occurred. Your credit card was not charged.');
    });

  }).then(function(purchase) {
    // Credit card charged! Now we save the ID of the purchase on our
    // order and mark it as 'charged'.
    order.set('stripePaymentId', purchase.id);
    order.set('charged', true);
    if(request.params.itemName == "Membership") {

      // Update the membership 
      var currentUser = Parse.User.current();
      var CUMembers = Parse.Object.extend("CUMembers");
      var cuMember = new CUMembers();
      cuMember.set('memberUserID', currentUser.objectId);
      cuMember.set('memberUser', currentUser);
      cuMember.set('expireDate', new Date("October 1, 2015 00:00:00"));

      cuMember.save(null, {
        success: function(cuMember) {
          console.log('New CUMembers object saved successfully');
        },
        error: function(cuMember, error) {
          console.log('Failed to save a new CUMembers object');
        }
      });

      //update the user it self
      currentUser.set("cuMember", cuMember);
      currentUser.save(null, {
        success: function(currentUser) {
          console.log('Current user cuMember field updated successfully');
        },
        error: function(cuMember, error) {
          console.log('Failed to update the cuMember field in currentUser');
        }
      });
    }


    // Save updated order
    return order.save().then(null, function(error) {
      // This is the worst place to fail since the card was charged but the order's
      // 'charged' field was not set. Here we need the user to contact us and give us
      // details of their credit card (last 4 digits) and we can then find the payment
      // on Stripe's dashboard to confirm which order to rectify. 
      return Parse.Promise.error('A critical error has occurred with your order. Please ' + 
                                 'contact CU Staff at your earliest convinience. ');
    });

  }).then(function(order) {
    // Credit card charged and order item updated properly!
    // We're done, so let's send an email to the user.

    // Generate the email body string.
    var body = "We've received and processed your order for the following item: \n\n" +
               "Item: " + request.params.itemName + "\n";

    if (request.params.size && request.params.size !== "N/A") {
      body += "Size: " + request.params.size + "\n";
    }

    body += "\nPrice: $" + item.get('price') + ".00 \n" +
            "Shipping Address: \n" +
            request.params.name + "\n" +
            request.params.address + "\n" +
            request.params.city_state + "," +
            "United States, " + request.params.zip + "\n" +
            "\nWe will send your item as soon as possible. " + 
            "Let us know if you have any questions!\n\n" +
            "Thank you,\n" +
            "The Parse Team";

    // Send the email.
    return Mailgun.sendEmail({
      to: request.params.email,
      from: 'store@parse.com',
      subject: 'Your order for a Parse ' + request.params.itemName + ' was successful!',
      text: body
    }).then(null, function(error) {
      return Parse.Promise.error('Your purchase was successful, but we were not able to ' +
                                 'send you an email. Contact us at store@parse.com if ' +
                                 'you have any questions.');
    });

  }).then(function() {
    // And we're done!
    response.success('Success');

  // Any promise that throws an error will propagate to this handler.
  // We use it to return the error from our Cloud Function using the 
  // message we individually crafted based on the failure above.
  }, function(error) {
    response.error(error);
  });
});
