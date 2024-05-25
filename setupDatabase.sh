#!/bin/bash

# Install Node.js and npm if not already installed
if ! command -v node &> /dev/null
then
    echo "Node.js not found. Installing..."
    curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -
    sudo apt-get install -y nodejs
fi

# Install MongoDB dependencies
npm install mongoose config

# Create project directory structure
mkdir -p myproject/{config,models,scripts}

# Create config/default.json
cat <<EOL > myproject/config/default.json
{
  "mongoURI": "YOUR_MONGODB_ATLAS_URI"
}
EOL

# Create models/user.js
cat <<EOL > myproject/models/user.js
const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const UserSchema = new Schema({
  name: String,
  dob: Date,
  email: String,
  addresses: [
    {
      tag: String,
      address: String,
      googlePin: String
    }
  ],
  foodPreferences: {
    veg: Boolean,
    preferences: [String],
    healthConditions: [String],
    noNonVegDays: [String]
  }
});

module.exports = mongoose.model('User', UserSchema);
EOL

# Create models/restaurant.js
cat <<EOL > myproject/models/restaurant.js
const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const RestaurantSchema = new Schema({
  name: String,
  menu: [
    {
      dish: String,
      portionSize: String,
      price: Number,
      picture: String
    }
  ],
  address: String,
  googlePin: String,
  branches: [String]
});

module.exports = mongoose.model('Restaurant', RestaurantSchema);
EOL

# Create scripts/setupDatabase.js
cat <<EOL > myproject/scripts/setupDatabase.js
const mongoose = require('mongoose');
const config = require('config');

// MongoDB connection URI
const mongoURI = config.get('mongoURI');

// Connect to MongoDB
mongoose.connect(mongoURI, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log('MongoDB connected'))
  .catch(err => console.log(err));

// Define User Schema
const userSchema = new mongoose.Schema({
  name: String,
  dob: Date,
  email: String,
  addresses: [
    {
      tag: String,
      address: String,
      googlePin: String
    }
  ],
  foodPreferences: {
    veg: Boolean,
    preferences: [String],
    healthConditions: [String],
    noNonVegDays: [String]
  }
});

// Define Restaurant Schema
const restaurantSchema = new mongoose.Schema({
  name: String,
  menu: [
    {
      dish: String,
      portionSize: String,
      price: Number,
      picture: String
    }
  ],
  address: String,
  googlePin: String,
  branches: [String]
});

// Create Models
const User = mongoose.model('User', userSchema);
const Restaurant = mongoose.model('Restaurant', restaurantSchema);

// Sample data
const users = [
  {
    name: "John Doe",
    dob: new Date("1990-01-01"),
    email: "john.doe@example.com",
    addresses: [
      {
        tag: "home",
        address: "123 Main St, Anytown, USA",
        googlePin: "11.1111, -111.1111"
      }
    ],
    foodPreferences: {
      veg: true,
      preferences: ["Chinese", "Italian"],
      healthConditions: ["Diabetes"],
      noNonVegDays: ["Monday", "Thursday"]
    }
  },
  {
    name: "Jane Smith",
    dob: new Date("1985-05-15"),
    email: "jane.smith@example.com",
    addresses: [
      {
        tag: "work",
        address: "456 Office Rd, Job City, USA",
        googlePin: "33.3333, -333.3333"
      }
    ],
    foodPreferences: {
      veg: false,
      preferences: ["Mexican", "Indian"],
      healthConditions: ["None"],
      noNonVegDays: []
    }
  }
];

const restaurants = [
  {
    name: "Good Eats",
    menu: [
      {
        dish: "Spicy Noodles",
        portionSize: "Full",
        price: 10,
        picture: "spicy_noodles.jpg"
      },
      {
        dish: "Sweet and Sour Chicken",
        portionSize: "Half",
        price: 8,
        picture: "sweet_sour_chicken.jpg"
      }
    ],
    address: "456 Food St, Tasty City, USA",
    googlePin: "22.2222, -222.2222",
    branches: ["Branch 1", "Branch 2"]
  },
  {
    name: "Tasty Bites",
    menu: [
      {
        dish: "Garlic Bread",
        portionSize: "Full",
        price: 5,
        picture: "garlic_bread.jpg"
      },
      {
        dish: "Margherita Pizza",
        portionSize: "Medium",
        price: 12,
        picture: "margherita_pizza.jpg"
      }
    ],
    address: "789 Yum Ave, Flavor Town, USA",
    googlePin: "44.4444, -444.4444",
    branches: ["Branch A", "Branch B"]
  }
];

// Insert sample data
const insertData = async () => {
  try {
    await User.deleteMany();
    await Restaurant.deleteMany();
    await User.insertMany(users);
    await Restaurant.insertMany(restaurants);
    console.log('Sample data inserted successfully');
    process.exit();
  } catch (error) {
    console.error('Error inserting sample data:', error);
    process.exit(1);
  }
};

// Run the insertData function
insertData();
EOL

# Run the setupDatabase script
node myproject/scripts/setupDatabase.js

echo "Database setup complete."

