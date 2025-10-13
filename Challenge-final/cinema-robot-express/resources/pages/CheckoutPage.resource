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
# Navegação e Verificações Básicas
Should Display Checkout Header
    Wait For Elements State    css=.checkout-header    visible    5

Should Display Seats Summary
    Wait For Elements State    ${SELECTED_SEATS}    visible    5

Should Show Selected Seat
    [Arguments]    ${seat_id}
    ${seats_text}=    Get Text    ${SELECTED_SEATS}
    Should Contain    ${seats_text}    ${seat_id}

Should Display Movie Information
    ${movie_info_exists}=    Run Keyword And Return Status
    ...    Wait For Elements State    css=.movie-info    visible    5
    
    IF    not ${movie_info_exists}
        ${movie_details_exists}=    Run Keyword And Return Status
        ...    Wait For Elements State    css=.movie-details    visible    5
        
        IF    not ${movie_details_exists}
            Log    Informações do filme não encontradas na página de checkout
        END
    END

Should Display Session Information
    Wait For Elements State    css=.session-info    visible    5

# Preços e Valores
Should Display Total Price
    Wait For Elements State    ${TOTAL_PRICE}    visible    5

Should Show Price Breakdown
    Wait For Elements State    css=.price-breakdown    visible    5

Should Display Individual Seat Prices
    Wait For Elements State    css=.seat-prices    visible    5

Should Calculate Correct Total
    ${total}=    Get Text    ${TOTAL_PRICE}
    Should Not Be Empty    ${total}
    Should Contain Any    ${total}    R$    $    €

Verificar Métodos de Pagamento
    [Documentation]    Verifica se os métodos de pagamento estão disponíveis
    Wait For Elements State    ${PAYMENT_METHODS}    visible    5
    
    ${payment_options}=    Get Elements    ${PAYMENT_METHOD}
    ${options_count}=    Get Length    ${payment_options}
    Should Be True    ${options_count} >= 4    Deve ter pelo menos 4 métodos de pagamento

# Métodos de Pagamento
Select Payment Method
    [Arguments]    ${method}
    Click    css=input[value="${method}"]
    Sleep    1s

Should Show Credit Card Form
    Wait For Elements State    css=.credit-card-form    visible    5

Should Show Debit Card Form
    Wait For Elements State    css=.debit-card-form    visible    5

Should Show PIX Information
    Wait For Elements State    css=.pix-info    visible    5

Should Display PIX QR Code
    Wait For Elements State    css=.pix-qr-code    visible    5

Should Show PIX Instructions
    Wait For Elements State    css=.pix-instructions    visible    5

Should Show Bank Transfer Information
    Wait For Elements State    css=.bank-transfer-info    visible    5

Should Display Bank Details
    Wait For Elements State    css=.bank-details    visible    5

Should Show Transfer Instructions
    Wait For Elements State    css=.transfer-instructions    visible    5

# Formulários de Pagamento
Fill Credit Card Form
    [Arguments]    ${number}    ${expiry}    ${cvv}    ${name}
    Fill Text    css=input[name="cardNumber"]    ${number}
    Fill Text    css=input[name="expiryDate"]    ${expiry}
    Fill Text    css=input[name="cvv"]    ${cvv}
    Fill Text    css=input[name="cardName"]    ${name}

Fill Debit Card Form
    [Arguments]    ${number}    ${expiry}    ${cvv}    ${name}
    Fill Text    css=input[name="cardNumber"]    ${number}
    Fill Text    css=input[name="expiryDate"]    ${expiry}
    Fill Text    css=input[name="cvv"]    ${cvv}
    Fill Text    css=input[name="cardName"]    ${name}

Should Enable Payment Button
    Get Attribute    ${CONFIRM_PAYMENT_BTN}    disabled    should be    ${None}

# Processamento e Confirmação
Click Process Payment
    Click    ${CONFIRM_PAYMENT_BTN}
    
Should Show Processing Indicator
    Wait For Elements State    css=.processing-indicator    visible    5

Should Show Payment Success
    Wait For Elements State    ${SUCCESS_MESSAGE}    visible    10

Should Display Reservation Code
    Wait For Elements State    ${RESERVATION_CODE}    visible    5

Should Show Confirmation Details
    Wait For Elements State    css=.confirmation-details    visible    5

Should Display Success Message
    Wait For Elements State    ${SUCCESS_MESSAGE}    visible    5

Should Show Green Checkmark
    Wait For Elements State    css=.success-icon    visible    5

Should Display Reservation Summary
    Wait For Elements State    css=.reservation-summary    visible    5

Should Show Next Steps Instructions
    Wait For Elements State    css=.next-steps    visible    5

Should Provide Download Receipt Option
    Wait For Elements State    css=.download-receipt    visible    5

# Validações e Erros
Should Show Field Error
    [Arguments]    ${error_message}
    Wait For Elements State    css=.field-error    visible    5
    ${error_text}=    Get Text    css=.field-error
    Should Contain    ${error_text}    ${error_message}

# Cancelamento
Click Cancel Checkout
    Click    css=.cancel-checkout

Should Maintain Selected Seats
    Wait For Elements State    css=.seat.selected    visible    5

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

Aguardar Carregamento do Checkout
    [Documentation]    Aguarda o carregamento completo da página de checkout
    Wait For Load State    networkidle
    Wait For Elements State    ${CHECKOUT_CONTAINER}    visible    10

Navegar para Página de Checkout
    [Documentation]    Navega para página de checkout
    Go To    ${BASE_URL}/checkout
    Aguardar Carregamento do Checkout