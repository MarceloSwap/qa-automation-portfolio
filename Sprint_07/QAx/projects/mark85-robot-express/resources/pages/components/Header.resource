*** Settings ***
Documentation        Ações e lementos do cabeça~jp dp mark85

Library        String
Library        Browser


*** Keywords ***

User should be logger in
    [Arguments]        ${name}

    @{splite_name}        Split String    ${name}
    Log      @{splite_name}
    ${element}        Set Variable        css=header .right small
    
    #Valida que o elemento etará visivel
    Wait For Elements State     ${element}    visible    5
    #Valida o texto que aparece no elemento - pega o valor que está na primeira posição da lista splite_name, ou seja o primeiro nome
    Get Text                    ${element}    equal    Olá, ${splite_name}[0]