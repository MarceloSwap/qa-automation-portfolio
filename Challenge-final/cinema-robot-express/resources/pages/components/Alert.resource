*** Settings ***
Documentation        Ações e lementos do componente de mensagens de alertas

Resource        ../../../resources/base.resource

*** Keywords ***

Alert should be
    [Arguments]        ${expected_text}

    # Este seletor foi atualizado para procurar tanto por '.alert-error'
    # QUANTO por '.alert-content' que contenha o texto esperado.
    # A vírgula no seletor CSS funciona como um "OU".
    Wait For Elements State    css=.alert-error, .alert-content >> text=${expected_text}    visible    timeout=5s
