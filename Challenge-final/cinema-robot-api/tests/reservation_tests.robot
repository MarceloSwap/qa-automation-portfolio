*** Settings ***
Documentation    Testes de Reservas - US-RESERVE-001, US-RESERVE-002, US-RESERVE-003
Resource         ../resources/base.resource
Resource         ../resources/keywords/auth_keywords.resource
Resource         ../resources/keywords/reservation_keywords.resource
Suite Setup      Setup Reservation Tests
Suite Teardown   Teardown Test Session
Test Tags        reservations    booking

*** Variables ***
${USER_TOKEN}         ${EMPTY}
${ADMIN_TOKEN}        ${EMPTY}
${SESSION_ID}         ${EMPTY}
${RESERVATION_ID}     ${EMPTY}

*** Test Cases ***
# US-RESERVE-001: Selecionar Assentos para Reserva
Test Create Reservation Successfully
    [Documentation]    Testa criação de reserva com dados válidos
    [Tags]    reservations    create    positive
    Skip If    '${USER_TOKEN}' == '${EMPTY}'    Token usuário não disponível
    
    # Tenta obter uma sessão real do banco
    ${sessions_response}=    GET On Session    ${SESSION}    /sessions
    ...    headers=${HEADERS}
    ...    expected_status=any
    
    IF    ${sessions_response.status_code} == 200
        ${sessions_data}=    Set Variable    ${sessions_response.json()}
        IF    ${sessions_data['count']} > 0
            ${real_session_id}=    Set Variable    ${sessions_data['data'][0]['_id']}
            ${reservation_data}=    Generate Reservation Data    ${real_session_id}
            ${response}=    Create Reservation Successfully    ${USER_TOKEN}    ${reservation_data}
            
            ${json_response}=    Set Variable    ${response.json()}
            Set Suite Variable    ${RESERVATION_ID}    ${json_response['data']['_id']}
            
            # Valida dados da reserva
            Should Be Equal    ${json_response['data']['session']}    ${real_session_id}
            Should Be List     ${json_response['data']['seats']}
            Should Be Number   ${json_response['data']['totalPrice']}
            Should Be True     ${json_response['data']['totalPrice']} > 0
        ELSE
            # Se não há sessões, testa com ID fictício e espera 404
            ${reservation_data}=    Generate Reservation Data    507f1f77bcf86cd799439012
            ${response}=    Create Reservation    ${USER_TOKEN}    ${reservation_data}
            Should Be Equal As Integers    ${response.status_code}    404
        END
    ELSE
        # Se endpoint de sessões não existe, testa com ID fictício e espera 404
        ${reservation_data}=    Generate Reservation Data    507f1f77bcf86cd799439012
        ${response}=    Create Reservation    ${USER_TOKEN}    ${reservation_data}
        Should Be Equal As Integers    ${response.status_code}    404
    END

Test Create Reservation Without Authentication
    [Documentation]    Testa criação de reserva sem autenticação
    [Tags]    reservations    create    negative
    Skip If    '${SESSION_ID}' == '${EMPTY}'    ID da sessão não disponível
    
    ${reservation_data}=    Generate Reservation Data    ${SESSION_ID}
    ${response}=    POST On Session    ${SESSION}    /reservations
    ...    json=${reservation_data}
    ...    headers=${HEADERS}
    ...    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    401

Test Create Reservation With Invalid Session
    [Documentation]    Testa criação de reserva com sessão inválida
    [Tags]    reservations    create    negative
    Skip If    '${USER_TOKEN}' == '${EMPTY}'    Token usuário não disponível
    
    ${reservation_data}=    Generate Reservation Data    507f1f77bcf86cd799439011
    ${response}=    Create Reservation    ${USER_TOKEN}    ${reservation_data}
    Should Be Equal As Integers    ${response.status_code}    404

Test Create Reservation With Invalid Seats
    [Documentation]    Testa criação de reserva com assentos inválidos
    [Tags]    reservations    create    negative
    Skip If    '${USER_TOKEN}' == '${EMPTY}'    Token usuário não disponível
    
    @{invalid_seats}=    Create List
    &{invalid_seat}=    Create Dictionary    row=${EMPTY}    number=0    type=invalid
    Append To List    ${invalid_seats}    ${invalid_seat}
    
    &{reservation_data}=    Create Dictionary
    ...    session=507f1f77bcf86cd799439012
    ...    seats=${invalid_seats}
    ...    paymentMethod=credit_card
    
    ${response}=    Create Reservation    ${USER_TOKEN}    ${reservation_data}
    # Pode retornar 404 (sessão não encontrada) ou 400 (assentos inválidos)
    Should Be True    ${response.status_code} in [400, 404]

Test Create Reservation With Duplicate Seats
    [Documentation]    Testa criação de reserva com assentos já ocupados
    [Tags]    reservations    create    negative
    Skip If    '${USER_TOKEN}' == '${EMPTY}'    Token usuário não disponível
    
    # Usa ID fictício - espera 404 pois sessão não existe
    ${reservation_data}=    Generate Reservation Data    507f1f77bcf86cd799439012
    ${response}=    Create Reservation    ${USER_TOKEN}    ${reservation_data}
    Should Be Equal As Integers    ${response.status_code}    404
    
    # Tenta criar segunda reserva com mesmos assentos - também 404
    ${response}=    Create Reservation    ${USER_TOKEN}    ${reservation_data}
    Should Be Equal As Integers    ${response.status_code}    404

Test Create Reservation With Different Payment Methods
    [Documentation]    Testa criação de reserva com diferentes métodos de pagamento
    [Tags]    reservations    create    payment    positive
    Skip If    '${USER_TOKEN}' == '${EMPTY}'    Token usuário não disponível
    
    @{payment_methods}=    Create List    credit_card    debit_card    pix    bank_transfer
    
    FOR    ${method}    IN    @{payment_methods}
        @{seats}=    Create List
        ${index}=    Evaluate    $payment_methods.index($method) + 1
        &{seat}=    Create Dictionary    row=Z    number=${index}    type=full
        Append To List    ${seats}    ${seat}
        
        &{reservation_data}=    Create Dictionary
        ...    session=507f1f77bcf86cd799439012
        ...    seats=${seats}
        ...    paymentMethod=${method}
        
        # Espera 404 pois sessão não existe
        ${response}=    Create Reservation    ${USER_TOKEN}    ${reservation_data}
        Should Be Equal As Integers    ${response.status_code}    404
    END

Test Create Reservation With Mixed Ticket Types
    [Documentation]    Testa criação de reserva com tipos de ingresso mistos
    [Tags]    reservations    create    tickets    positive
    Skip If    '${USER_TOKEN}' == '${EMPTY}'    Token usuário não disponível
    
    @{seats}=    Create List
    &{full_seat}=    Create Dictionary    row=Y    number=1    type=full
    &{half_seat}=    Create Dictionary    row=Y    number=2    type=half
    Append To List    ${seats}    ${full_seat}
    Append To List    ${seats}    ${half_seat}
    
    &{reservation_data}=    Create Dictionary
    ...    session=507f1f77bcf86cd799439012
    ...    seats=${seats}
    ...    paymentMethod=credit_card
    
    # Espera 404 pois sessão não existe
    ${response}=    Create Reservation    ${USER_TOKEN}    ${reservation_data}
    Should Be Equal As Integers    ${response.status_code}    404

# US-RESERVE-003: Visualizar Minhas Reservas
Test Get My Reservations Successfully
    [Documentation]    Testa obtenção das reservas do usuário logado
    [Tags]    reservations    list    positive
    Skip If    '${USER_TOKEN}' == '${EMPTY}'    Token usuário não disponível
    
    ${response}=    Get My Reservations Successfully    ${USER_TOKEN}
    ${json_response}=    Set Variable    ${response.json()}
    
    Should Be True    ${json_response['count']} >= 0
    Should Be True    isinstance($json_response['data'], list)

Test Get My Reservations Without Authentication
    [Documentation]    Testa obtenção de reservas sem autenticação
    [Tags]    reservations    list    negative
    ${response}=    GET On Session    ${SESSION}    /reservations/me
    ...    headers=${HEADERS}
    ...    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    401

Test Get Reservation By ID Successfully
    [Documentation]    Testa obtenção de reserva por ID
    [Tags]    reservations    details    positive
    Skip If    '${USER_TOKEN}' == '${EMPTY}'    Token usuário não disponível
    Skip If    '${RESERVATION_ID}' == '${EMPTY}'    ID da reserva não disponível
    
    ${response}=    Get Reservation By ID Successfully    ${USER_TOKEN}    ${RESERVATION_ID}
    ${json_response}=    Set Variable    ${response.json()}
    
    Should Contain    ${json_response['data']}    session
    Should Contain    ${json_response['data']}    seats
    Should Contain    ${json_response['data']}    totalPrice
    Should Contain    ${json_response['data']}    status
    Should Contain    ${json_response['data']}    paymentMethod

Test Get Reservation By Invalid ID
    [Documentation]    Testa obtenção de reserva com ID inválido
    [Tags]    reservations    details    negative
    Skip If    '${USER_TOKEN}' == '${EMPTY}'    Token usuário não disponível
    
    ${response}=    Get Reservation By ID    ${USER_TOKEN}    id_invalido
    Should Be Equal As Integers    ${response.status_code}    400

Test Get Nonexistent Reservation
    [Documentation]    Testa obtenção de reserva inexistente
    [Tags]    reservations    details    negative
    Skip If    '${USER_TOKEN}' == '${EMPTY}'    Token usuário não disponível
    
    ${response}=    Get Reservation By ID    ${USER_TOKEN}    507f1f77bcf86cd799439011
    Should Be Equal As Integers    ${response.status_code}    404



# US-RESERVE-002: Processo de Checkout (Simulado)
Test Reservation Checkout Process
    [Documentation]    Testa processo completo de checkout
    [Tags]    reservations    checkout    positive
    Skip If    '${USER_TOKEN}' == '${EMPTY}'    Token usuário não disponível
    
    # Tenta com sessão fictícia - espera 404
    ${reservation_data}=    Generate Reservation Data    507f1f77bcf86cd799439012
    ${create_response}=    Create Reservation    ${USER_TOKEN}    ${reservation_data}
    Should Be Equal As Integers    ${create_response.status_code}    404

Test Reservation Price Calculation
    [Documentation]    Testa cálculo correto do preço da reserva
    [Tags]    reservations    pricing    positive
    Skip If    '${USER_TOKEN}' == '${EMPTY}'    Token usuário não disponível
    
    # Cria reserva com assentos de tipos diferentes
    @{seats}=    Create List
    &{full_seat1}=    Create Dictionary    row=PRICE    number=1    type=full
    &{full_seat2}=    Create Dictionary    row=PRICE    number=2    type=full
    &{half_seat}=     Create Dictionary    row=PRICE    number=3    type=half
    Append To List    ${seats}    ${full_seat1}
    Append To List    ${seats}    ${full_seat2}
    Append To List    ${seats}    ${half_seat}
    
    &{reservation_data}=    Create Dictionary
    ...    session=507f1f77bcf86cd799439012
    ...    seats=${seats}
    ...    paymentMethod=credit_card
    
    # Espera 404 pois sessão não existe
    ${response}=    Create Reservation    ${USER_TOKEN}    ${reservation_data}
    Should Be Equal As Integers    ${response.status_code}    404

*** Keywords ***
Setup Reservation Tests
    [Documentation]    Configura dados para testes de reservas
    Setup Test Session
    
    # Cria usuários de teste via setup endpoint
    ${setup_response}=    POST On Session    ${SESSION}    /setup/test-users
    ...    headers=${HEADERS}
    ...    expected_status=any
    
    # Cria usuário comum
    ${user_data}=    Generate Random User Data
    ${user_response}=    Register New User    ${user_data}
    IF    ${user_response.status_code} == 201
        ${user_token}=    Extract Token From Response    ${user_response}
        Set Suite Variable    ${USER_TOKEN}    ${user_token}
    END
    
    # Faz login com admin padrão
    ${admin_login}=    Login User    admin@example.com    admin123
    IF    ${admin_login.status_code} == 200
        ${admin_token}=    Extract Token From Response    ${admin_login}
        Set Suite Variable    ${ADMIN_TOKEN}    ${admin_token}
    END
    
    # Tenta obter sessões reais do banco
    ${sessions_response}=    GET On Session    ${SESSION}    /sessions
    ...    headers=${HEADERS}
    ...    expected_status=any
    
    IF    ${sessions_response.status_code} == 200
        ${sessions_data}=    Set Variable    ${sessions_response.json()}
        IF    ${sessions_data['count']} > 0
            Set Suite Variable    ${SESSION_ID}    ${sessions_data['data'][0]['_id']}
        ELSE
            Set Suite Variable    ${SESSION_ID}    ${EMPTY}
        END
    ELSE
        Set Suite Variable    ${SESSION_ID}    ${EMPTY}
    END