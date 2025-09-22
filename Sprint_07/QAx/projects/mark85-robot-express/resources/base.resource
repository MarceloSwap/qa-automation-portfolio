*** Settings ***

Library        libs/database.py
Library        Browser

Resource       env.resource
Resource       pages/SignupPage.resource
Resource       pages/LoginPage.resource

*** Keywords ***
Start Session
    
    New Browser     browser=chromium      headless=False
    New Page        ${BASE_URL}

