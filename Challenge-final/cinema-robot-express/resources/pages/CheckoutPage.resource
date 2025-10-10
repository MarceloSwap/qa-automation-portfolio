*** Settings ***
Documentation        Elementos e ações da página de checkout

Library        Browser
Resource       ../env.resource

*** Variables ***
# Seletores da página de checkout
${CHECKOUT_CONTAINER}     css=.checkout-container
${RESERVATION_SUMMARY}    css=.reservation-summary
${SELECTED_SEATS}         css=.selected-seats
${TOTAL_PRICE}            css=.total-price
${PAYMENT_METHODS}        css=.payment-methods
${PAYMENT_METHOD}         css=.payment-method
${CREDIT_CARD_OPTION}     css=input[value="credit_card"]
${DEBIT_CARD_OPTION}      css=input[value="debit_card"]
${PIX_OPTION}             css=input[value="pix"]
${TRANSFER_OPTION}        css=input[value="bank_transfer"]
${CONFIRM_PAYMENT_BTN}    css=.confirm-payment-btn
${SUCCESS_MESSAGE}        css=.success-message
${RESERVATION_CODE}       css=.reservation-code

*** Keywords ***
Aguardar Carregamento do Checkout
    [Documentation]    Aguarda o carregamento da página de checkout
    Wait For Elements State    ${CHECKOUT_CONTAINER}    visible    10
    Wait For Load State        networkidle

Verificar Resumo da Reserva
    [Documentation]    Verifica se o resumo da reserva está presente
    Wait For Elements State    ${RESERVATION_SUMMARY}    visible    5
    
    # Verifica assentos selecionados
    Wait For Elements State    ${SELECTED_SEATS}    visible    5
    ${seats_text}=    Get Text    ${SELECTED_SEATS}
    Should Not Be Empty    ${seats_text}
    
    # Verifica valor total
    Wait For Elements State    ${TOTAL_PRICE}    visible    5
    ${total_text}=    Get Text    ${TOTAL_PRICE}
    Should Not Be Empty    ${total_text}
    Should Contain Any    ${total_text}    R$    $    €

Verificar Métodos de Pagamento
    [Documentation]    Verifica se os métodos de pagamento estão disponíveis
    Wait For Elements State    ${PAYMENT_METHODS}    visible    5
    
    ${payment_options}=    Get Elements    ${PAYMENT_METHOD}
    ${options_count}=    Get Length    ${payment_options}
    Should Be True    ${options_count} >= 4    Deve ter pelo menos 4 métodos de pagamento

Selecionar Método de Pagamento
    [Documentation]    Seleciona um método de pagamento específico
    [Arguments]    ${method}=credit_card
    
    IF    '${method}' == 'credit_card'
        Click    ${CREDIT_CARD_OPTION}
    ELSE IF    '${method}' == 'debit_card'
        Click    ${DEBIT_CARD_OPTION}
    ELSE IF    '${method}' == 'pix'
        Click    ${PIX_OPTION}
    ELSE IF    '${method}' == 'bank_transfer'
        Click    ${TRANSFER_OPTION}
    ELSE
        Fail    Método de pagamento inválido: ${method}
    END
    
    Sleep    1s

Confirmar Pagamento
    [Documentation]    Confirma o pagamento e finaliza a reserva
    Click    ${CONFIRM_PAYMENT_BTN}
    Wait For Load State    networkidle

Verificar Confirmação de Sucesso
    [Documentation]    Verifica se a confirmação de sucesso foi exibida
    Wait For Elements State    ${SUCCESS_MESSAGE}    visible    10
    ${success_text}=    Get Text    ${SUCCESS_MESSAGE}
    Should Not Be Empty    ${success_text}
    Should Contain Any    ${success_text}    sucesso    confirmada    reserva

Obter Código da Reserva
    [Documentation]    Obtém o código da reserva gerada
    ${code_exists}=    Run Keyword And Return Status
    ...    Wait For Elements State    ${RESERVATION_CODE}    visible    5
    
    IF    ${code_exists}
        ${code}=    Get Text    ${RESERVATION_CODE}
        Should Not Be Empty    ${code}
        RETURN    ${code}
    ELSE
        RETURN    ${EMPTY}
    END

Navegar para Página de Checkout
    [Documentation]    Navega para página de checkout
    Go To    ${BASE_URL}/checkout
    Aguardar Carregamento do Checkout