*** Settings ***
Documentation        Elementos e ações da página de cadastro

Library        Browser
Resource       ../env.resource


*** Keywords ***
Go to signup page
    Go To    ${BASE_URL}/register

    # Tecnica Chekpoint (End-to-end)
    Wait For Elements State     css=#root > main > div > div > p      visible     5
    Get Text                    css=#root > main > div > div > p      equal       Crie sua conta para reservar ingressos



Submit signup form
    [Arguments]    ${user}

    # Usando o seletor de ID (css=#) que é mais específico e confiável
    Fill Text    css=#name               ${user}[name]
    Fill Text    css=#email              ${user}[email]
    Fill Text    css=#password           ${user}[password]
    Fill Text    css=#confirmPassword    ${user}[password]  # Supondo que a senha é a mesma

    # Seu seletor para o botão já estava ótimo!
    Click        css=button[type=submit] >> text=Cadastrar
