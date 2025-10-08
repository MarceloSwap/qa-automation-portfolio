*** Settings ***
Documentation        Ações e elementos do componente de noticifações

Resource        ../../../resources/base.resource

*** Keywords ***
Notice should be
    [Arguments]    ${expected_message}

    # Com base no seu código JS e no seu teste de alerta de erro,
    # este é o seletor correto para a mensagem de sucesso.
    ${selector}=    Set Variable    css=.alert-success

    # Espera o elemento ficar visível
    Wait For Elements State    ${selector}    visible    timeout=5s

    # Pega o texto do elemento e verifica se é igual ao esperado
    Get Text                   ${selector}    equal    ${expected_message}

