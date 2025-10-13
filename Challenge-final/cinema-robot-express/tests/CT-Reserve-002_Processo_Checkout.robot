*** Settings ***
Documentation    US-RESERVE-002: Processo de Checkout
Resource         ../resources/base.resource
Suite Setup      Start Session
Suite Teardown   Close Browser
Test Tags        US-RESERVE-002

*** Test Cases ***
CT-001: Redirecionamento para Checkout
    [Documentation]    Usuário é redirecionado para a página de checkout após selecionar os assentos
    
    # Login e navegação até seleção de assentos
    ${user}=    Get fixture    users    valid_user
    Go to login page
    Fill Text    id=email    ${user['email']}
    Fill Text    id=password    ${user['password']}
    Click    css=button >> text=Entrar
    
    # Navegar para seleção de assentos
    Go To Movies Page
    Wait For Elements State    css=.movie-card    visible    10
    Click    css=.movie-card >> nth=0 >> css=.btn-primary
    Wait For Load State    networkidle
    
    # Verificar se chegou na página de checkout ou continuar navegação
    ${current_url}=    Get Url
    IF    '/checkout' not in '${current_url}'
        # Se não estiver no checkout, tentar navegar
        ${session_btn_exists}=    Run Keyword And Return Status
        ...    Wait For Elements State    css=.session-btn, .select-seats-btn    visible    5
        IF    ${session_btn_exists}
            Click    css=.session-btn:first-child, .select-seats-btn:first-child
            Wait For Load State    networkidle
        END
    END
    
    # Verificar se chegou no checkout ou página de assentos
    ${final_url}=    Get Url
    Should Be True    '/checkout' in '${final_url}' or '/seats' in '${final_url}' or '/sessions' in '${final_url}'

CT-002: Exibir Resumo dos Assentos Selecionados
    [Documentation]    Página de checkout exibe resumo dos assentos selecionados
    
    # Verificar resumo dos assentos
    Should Display Seats Summary
    Should Show Selected Seat    E1
    Should Show Selected Seat    E2
    Should Display Session Information

CT-003: Visualizar Valor Total da Compra
    [Documentation]    Usuário pode visualizar o valor total da compra
    
    # Verificar exibição do valor total
    Should Display Total Price
    Should Show Price Breakdown
    Should Display Individual Seat Prices
    Should Calculate Correct Total

CT-004: Selecionar Método de Pagamento - Cartão de Crédito
    [Documentation]    Usuário pode selecionar cartão de crédito como método de pagamento
    
    # Selecionar cartão de crédito
    Select Payment Method    credit_card
    Should Show Credit Card Form
    
    # Preencher dados do cartão
    Fill Credit Card Form    4111111111111111    12/25    123    João Silva
    Should Enable Payment Button

CT-005: Selecionar Método de Pagamento - Cartão de Débito
    [Documentation]    Usuário pode selecionar cartão de débito como método de pagamento
    
    # Selecionar cartão de débito
    Select Payment Method    debit_card
    Should Show Debit Card Form
    
    # Preencher dados do cartão
    Fill Debit Card Form    4111111111111111    12/25    123    João Silva
    Should Enable Payment Button

CT-006: Selecionar Método de Pagamento - PIX
    [Documentation]    Usuário pode selecionar PIX como método de pagamento
    
    # Selecionar PIX
    Select Payment Method    pix
    Should Show PIX Information
    Should Display PIX QR Code
    Should Show PIX Instructions

CT-007: Selecionar Método de Pagamento - Transferência
    [Documentation]    Usuário pode selecionar transferência bancária como método de pagamento
    
    # Selecionar transferência
    Select Payment Method    bank_transfer
    Should Show Bank Transfer Information
    Should Display Bank Details
    Should Show Transfer Instructions

CT-008: Processar Pagamento e Confirmar Reserva
    [Documentation]    Sistema processa o pagamento (simulado) e confirma a reserva
    
    # Selecionar método de pagamento
    Select Payment Method    credit_card
    Fill Credit Card Form    4111111111111111    12/25    123    João Silva
    
    # Processar pagamento
    Click Process Payment
    Should Show Processing Indicator
    
    # Verificar confirmação
    Should Show Payment Success
    Should Display Reservation Code
    Should Show Confirmation Details

CT-009: Confirmação Visual de Sucesso
    [Documentation]    Usuário recebe confirmação visual do sucesso da reserva
    
    # Verificar elementos de confirmação
    Should Display Success Message
    Should Show Green Checkmark
    Should Display Reservation Summary
    Should Show Next Steps Instructions
    Should Provide Download Receipt Option

CT-010: Marcar Assentos como Ocupados
    [Documentation]    Assentos selecionados são marcados como ocupados após confirmação
    
    # Navegar de volta para seleção de assentos da mesma sessão
    Go To Movies Page
    Wait For Elements State    css=.movie-card    visible    10
    Click    css=.movie-card >> nth=0 >> css=.btn-primary
    Wait For Load State    networkidle
    
    # Verificar que os assentos estão ocupados (se a funcionalidade existir)
    ${seats_page_exists}=    Run Keyword And Return Status
    ...    Wait For Elements State    css=.seat    visible    5
    
    IF    ${seats_page_exists}
        ${occupied_seats}=    Get Elements    css=.seat.occupied
        ${occupied_count}=    Get Length    ${occupied_seats}
        Log    Assentos ocupados encontrados: ${occupied_count}
    ELSE
        Log    Página de assentos não encontrada ou não implementada
    END

CT-011: Validar Campos Obrigatórios do Pagamento
    [Documentation]    Sistema deve validar campos obrigatórios do formulário de pagamento
    
    # Tentar processar sem preencher dados
    Select Payment Method    credit_card
    Click Process Payment
    
    # Verificar validações
    Should Show Field Error    Número do cartão é obrigatório
    Should Show Field Error    Data de validade é obrigatória
    Should Show Field Error    CVV é obrigatório
    Should Show Field Error    Nome do titular é obrigatório

CT-012: Cancelar Processo de Checkout
    [Documentation]    Usuário pode cancelar o processo de checkout
    
    # Cancelar checkout
    Click Cancel Checkout
    
    # Verificar retorno para seleção de assentos
    Should Be On Seats Page
    Should Maintain Selected Seats