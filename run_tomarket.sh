#!/bin/bash

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to install packages
install_packages() {
    echo -e "${BLUE}Updating and upgrading packages...${NC}"
    pkg update && pkg upgrade -y

    echo -e "${GREEN}Installing git and nano...${NC}"
    pkg install git nano -y

    echo -e "${GREEN}Installing development tools: clang, cmake, ninja, rust, make...${NC}"
    pkg install clang cmake ninja rust make -y

    echo -e "${GREEN}Installing tur-repo...${NC}"
    pkg install tur-repo -y

    echo -e "${GREEN}Installing Python 3.10...${NC}"
    pkg install python3.10 -y
}

# Check if tomarketod directory exists
if [ ! -d "tomarketod" ]; then
    # If the directory does not exist, install everything
    install_packages

    # Upgrade pip and install wheel
    echo -e "${BLUE}Upgrading pip and installing wheel...${NC}"
    pip3.10 install --upgrade pip wheel --quiet

    # Clone the tomarketod repository
    echo -e "${BLUE}Cloning tomarketod repository...${NC}"
    git clone https://github.com/rjfahad/tomarketod.git

    # Change directory to tomarketod
    echo -e "${BLUE}Navigating to tomarketod directory...${NC}"
    cd tomarketod || exit

    # Open config.json file for editing
    echo -e "${YELLOW}Opening config.json file for editing...${NC}"
    nano config.json

    # Set up Python virtual environment
    echo -e "${BLUE}Setting up Python virtual environment...${NC}"
    python3.10 -m venv venv

    # Activate the virtual environment
    echo -e "${BLUE}Activating Python virtual environment...${NC}"
    source venv/bin/activate

    # Install required Python packages
    echo -e "${BLUE}Installing Python dependencies from requirements.txt...${NC}"
    pip3.10 install -r requirements.txt --quiet

    echo -e "${GREEN}Installation completed! You can now run the bot.${NC}"

else
    # If the directory exists, just navigate to it
    echo -e "${GREEN}tomarketod is already installed. Navigating to the directory...${NC}"
    cd tomarketod || exit

    # Check if the virtual environment exists and activate it
    if [ -f "venv/bin/activate" ]; then
        echo -e "${BLUE}Activating Python virtual environment...${NC}"
        source venv/bin/activate
    else
        # If the virtual environment does not exist, set it up
        echo -e "${BLUE}Setting up Python virtual environment...${NC}"
        python3.10 -m venv venv

        # Activate the virtual environment
        echo -e "${BLUE}Activating Python virtual environment...${NC}"
        source venv/bin/activate

        # Install required Python packages
        echo -e "${BLUE}Installing Python dependencies from requirements.txt...${NC}"
        pip3.10 install -r requirements.txt --quiet
    fi
fi

# Run the bot
echo -e "${GREEN}Running the bot...${NC}"
python3.10 bot.py

echo -e "${GREEN}Script execution completed!${NC}"
