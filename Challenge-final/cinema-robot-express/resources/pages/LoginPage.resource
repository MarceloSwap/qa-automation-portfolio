*** Settings ***
Documentation        Elementos e ações da página de login

Library        Browser
Resource       ../env.resource

*** Keywords ***
Go to login page
    Go To    ${BASE_URL}/login
    # Checkpoint para garantir que a página de login carregou
    Wait For Elements State    css=#root > main > div > div > div.login-header    visible    timeout=5s
    
Submit login form
    [Arguments]    ${user}

    Fill Text        id=email    ${user}[email]
    Fill Text        id=password    ${user}[password]

    Click            css=button >> text=Entrar
    # Click            id=buttonLogin
    # Click            Xpath=//button[text()="Entrar"]