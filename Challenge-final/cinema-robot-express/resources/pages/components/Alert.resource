*** Settings ***
Documentation        Ações e lementos do componente de mensagens de alertas

Resource        ../../../resources/base.resource

*** Keywords ***

Alert should be
    [Arguments]        ${expected_text}

    # Tenta múltiplos seletores para mensagens de erro
    TRY
        Wait For Elements State    css=.alert-error    visible    timeout=2s
        Get Text    css=.alert-error    equal    ${expected_text}
    EXCEPT
        TRY
            Wait For Elements State    css=.alert-danger    visible    timeout=2s
            Get Text    css=.alert-danger    equal    ${expected_text}
        EXCEPT
            TRY
                Wait For Elements State    css=.alert    visible    timeout=2s
                Get Text    css=.alert    equal    ${expected_text}
            EXCEPT
                Wait For Elements State    css=[role="alert"]    visible    timeout=2s
                Get Text    css=[role="alert"]    equal    ${expected_text}
            END
        END
    END

Alert should be email errado
    [Arguments]     ${expected_message}
    [Documentation]     Verifica se a mensagem de alerta/erro (vermelha, vinda da API) está visível.

    # **ATENÇÃO:** Tente estas opções. Se não funcionar, inspecione o elemento na página
    # e use o seletor exato (ID, classe, ou xpath) para a caixa vermelha.
    ${selector}=    Set Variable    css=.alert-danger 

    # 1. Espera o elemento de alerta ficar visível (CRUCIAL para mensagens que somem)
    Wait For Elements State    ${selector}    visible    timeout=5s

    # 2. Pega o texto do alerta e verifica se é EXATAMENTE igual ao esperado
    Get Text        ${selector}    equal    ${expected_message}
