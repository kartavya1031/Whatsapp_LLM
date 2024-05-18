const express = require('express');
     const bodyParser = require('body-parser');
     const axios = require('axios');

     const app = express();
     app.use(bodyParser.json());

     const phone_number_id = '9695926472';
     const access_token = '<YOUR_ACCESS_TOKEN>';

     app.post('/webhook', async (req, res) => {
       const message = req.body;
       if (message.entry && message.entry[0].changes && message.entry[0].changes[0].value.messages && message.entry[0].changes[0].value.messages[0]) {
         const phone_number = message.entry[0].changes[0].value.messages[0].from;
         const text = message.entry[0].changes[0].value.messages[0].text.body;

         await sendMessage(phone_number, "Welcome to our restaurant bot! How can I assist you today?");
       }
       res.sendStatus(200);
     });

     async function sendMessage(phone_number, text) {
       await axios.post(`https://graph.facebook.com/v12.0/${9695926472}/messages`, {
         messaging_product: 'whatsapp',
         to: phone_number,
         text: { body: text }
       }, {
         headers: {
           'Authorization': `Bearer ${access_token}`,
           'Content-Type': 'application/json'
         }
       });
     }

     const PORT = process.env.PORT || 3000;
     app.listen(PORT, () => {
       console.log(`Server is running on port ${PORT}`);
     });

