*** Settings ***
Documentation        Elementos e ações da página de cadastro

Library        Browser
# Resource        ../env.resource


*** Keywords ***
Notice should be
    [Arguments]       ${expected_texto}
    # A mensagem é passado como argumento para a variável ${expected_texto}

    ${element}        Set Variable        css=.notice p

    Wait For Elements State        ${element}      visible        5
    #Validação da mensagens de boas vindas pra garantir que foi cadastrado: Ex. Boas vindas ao Mark85
    Get Text                       ${element}      equal      ${expected_texto}
