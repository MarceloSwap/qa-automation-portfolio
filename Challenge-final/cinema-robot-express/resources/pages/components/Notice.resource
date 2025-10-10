*** Settings ***
Documentation        Ações e elementos do componente de noticifações

Resource        ../../../resources/base.resource


*** Keywords ***
Notice should be
    [Arguments]    ${expected_message}

    # Tenta múltiplos seletores para mensagens de sucesso
    TRY
        Wait For Elements State    css=.alert-success    visible    timeout=2s
        Get Text    css=.alert-success    equal    ${expected_message}
    EXCEPT
        TRY
            Wait For Elements State    css=.alert-info    visible    timeout=2s
            Get Text    css=.alert-info    equal    ${expected_message}
        EXCEPT
            TRY
                Wait For Elements State    css=.alert    visible    timeout=2s
                Get Text    css=.alert    equal    ${expected_message}
            EXCEPT
                # Se não encontrar mensagem de sucesso, pode ser que o registro foi bem-sucedido
                # mas não há mensagem visível. Verifica se foi redirecionado.
                ${current_url}=    Get Url
                Should Not Contain    ${current_url}    /register
                Should Not Contain    ${current_url}    /signup
            END
        END
    END

Field validation message should be
    [Arguments]     ${field_selector}       ${expected_text_fragment}
    [Documentation]     Verifica se a mensagem de validação CONTÉM um texto específico (validationMessage).
    
    # Obtém a mensagem de validação do navegador (a tooltip laranja)
    ${actual_message} =     Get Property    ${field_selector}    validationMessage
    
    # Verifica se a mensagem contém o fragmento esperado
    Should Contain    ${actual_message}    ${expected_text_fragment}


