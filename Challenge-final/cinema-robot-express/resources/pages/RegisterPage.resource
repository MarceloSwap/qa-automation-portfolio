*** Settings ***
Documentation        Elementos e ações da página de cadastro

Resource       ../base.resource

*** Keywords ***
Go to signup page
    Go To    ${BASE_URL}/register

    # Tecnica Chekpoint (End-to-end)
    Wait For Elements State     css=#root > main > div > div > p      visible     5
    Get Text                    css=#root > main > div > div > p      equal       Crie sua conta para reservar ingressos



Submit signup form
    [Arguments]     ${user}

    Fill Text       css=#name               ${user}[name]
    Fill Text       css=#email              ${user}[email]
    Fill Text       css=#password           ${user}[password]
    Fill Text       css=#confirmPassword    ${user}[password]

    Click           css=button[type=submit] >> text=Cadastrar

Fill signup form without submission
    [Arguments]     ${user}

    Fill Text       css=#name               ${user}[name]
    Fill Text       css=#email              ${user}[email]
    Fill Text       css=#password           ${user}[password]
    Fill Text       css=#confirmPassword    ${user}[password]
    Click        css=button[type=submit] >> text=Cadastrar


Fill signup fields
    [Arguments]     ${user}
    [Documentation]     Preenche os campos de cadastro sem submeter o formulário.

    Fill Text       css=#name               ${user}[name]
    Fill Text       css=#email              ${user}[email]
    Fill Text       css=#password           ${user}[password]
    Fill Text       css=#confirmPassword    ${user}[password] 