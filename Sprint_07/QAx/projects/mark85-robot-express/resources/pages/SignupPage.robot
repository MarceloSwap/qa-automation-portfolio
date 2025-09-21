*** Settings ***
Documentation        Elementos e ações da página de cadastro

Library        Browser
Resource        ../env.robot


*** Keywords ***
Go to signup page
    Go To    ${BASE_URL}/signup

    # Tecnica Chekpoint (End-to-end)
    Wait For Elements State     xpath=//h1      visible     5
    Get Text                    xpath=//h1      equal       Faça seu cadastro

Submit signup form
    [Arguments]        ${user}

    #Procurar por css name ou placehouder (caso não tenha id)
    Fill Text    css=input[name=name]           ${user}[name]
    Fill Text    css=input[name=email]          ${user}[email]  
    Fill Text    css=input[name=password]       ${user}[password]

    #Exemplo de combinação cd css com text
    Click        css=[type=submit] >> text=Cadastrar

Notice should be
    [Arguments]       ${expected_texto}
    # A mensagem é passado como argumento para a variável ${expected_texto}

    ${element}        Set Variable        css=.notice p

    Wait For Elements State        ${element}      visible        5
    #Validação da mensagens de boas vindas pra garantir que foi cadastrado: Ex. Boas vindas ao Mark85
    Get Text                       ${element}      equal      ${expected_texto}