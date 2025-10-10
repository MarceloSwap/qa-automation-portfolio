*** Settings ***
Documentation    Keywords para testes de reservas
Resource         ../base.resource

*** Keywords ***
Create Reservation
    [Documentation]    Cria uma nova reserva
    [Arguments]    ${token}    ${reservation_data}
    Set Authorization Header    ${token}
    ${response}=    POST On Session    ${SESSION}    /reservations
    ...    json=${reservation_data}
    ...    headers=${AUTH_HEADERS}
    ...    expected_status=any
    RETURN    ${response}

Create Reservation Successfully
    [Documentation]    Cria reserva com sucesso
    [Arguments]    ${token}    ${reservation_data}
    ${response}=    Create Reservation    ${token}    ${reservation_data}
    ${json_response}=    Validate Response Structure    ${response}    201
    Should Be True    ${json_response['success']}
    Should Contain    ${json_response}    data
    Should Contain    ${json_response['data']}    _id
    Should Contain    ${json_response['data']}    session
    Should Contain    ${json_response['data']}    seats
    Should Contain    ${json_response['data']}    totalPrice
    Should Contain    ${json_response['data']}    status
    Should Be Equal    ${json_response['data']['status']}    pending
    RETURN    ${response}

Get My Reservations
    [Documentation]    Obtém reservas do usuário logado
    [Arguments]    ${token}
    Set Authorization Header    ${token}
    ${response}=    GET On Session    ${SESSION}    /reservations/me
    ...    headers=${AUTH_HEADERS}
    ...    expected_status=any
    RETURN    ${response}

Get My Reservations Successfully
    [Documentation]    Obtém reservas do usuário com sucesso
    [Arguments]    ${token}
    ${response}=    Get My Reservations    ${token}
    ${json_response}=    Validate Response Structure    ${response}    200
    Should Be True    ${json_response['success']}
    Should Contain    ${json_response}    count
    Should Contain    ${json_response}    data
    Should Be True    ${json_response['count']} >= 0
    RETURN    ${response}

Get All Reservations
    [Documentation]    Obtém todas as reservas (admin)
    [Arguments]    ${token}    ${params}=${EMPTY}
    Set Authorization Header    ${token}
    ${response}=    GET On Session    ${SESSION}    /reservations
    ...    params=${params}
    ...    headers=${AUTH_HEADERS}
    ...    expected_status=any
    RETURN    ${response}

Get All Reservations Successfully
    [Documentation]    Obtém todas as reservas com sucesso (admin)
    [Arguments]    ${token}    ${params}=${EMPTY}
    ${response}=    Get All Reservations    ${token}    ${params}
    ${json_response}=    Validate Response Structure    ${response}    200
    Should Be True    ${json_response['success']}
    Should Contain    ${json_response}    count
    Should Contain    ${json_response}    data
    Should Be True    ${json_response['count']} >= 0
    RETURN    ${response}

Get Reservation By ID
    [Documentation]    Obtém reserva por ID
    [Arguments]    ${token}    ${reservation_id}
    Set Authorization Header    ${token}
    ${response}=    GET On Session    ${SESSION}    /reservations/${reservation_id}
    ...    headers=${AUTH_HEADERS}
    ...    expected_status=any
    RETURN    ${response}

Get Reservation By ID Successfully
    [Documentation]    Obtém reserva por ID com sucesso
    [Arguments]    ${token}    ${reservation_id}
    ${response}=    Get Reservation By ID    ${token}    ${reservation_id}
    ${json_response}=    Validate Response Structure    ${response}    200
    Should Be True    ${json_response['success']}
    Should Contain    ${json_response}    data
    Should Contain    ${json_response['data']}    _id
    Should Be Equal    ${json_response['data']['_id']}    ${reservation_id}
    RETURN    ${response}

Update Reservation Status
    [Documentation]    Atualiza status da reserva (admin)
    [Arguments]    ${token}    ${reservation_id}    ${status_data}
    Set Authorization Header    ${token}
    ${response}=    PUT On Session    ${SESSION}    /reservations/${reservation_id}
    ...    json=${status_data}
    ...    headers=${AUTH_HEADERS}
    ...    expected_status=any
    RETURN    ${response}

Update Reservation Status Successfully
    [Documentation]    Atualiza status da reserva com sucesso
    [Arguments]    ${token}    ${reservation_id}    ${status_data}
    ${response}=    Update Reservation Status    ${token}    ${reservation_id}    ${status_data}
    ${json_response}=    Validate Response Structure    ${response}    200
    Should Be True    ${json_response['success']}
    Should Contain    ${json_response}    data
    Should Be Equal    ${json_response['data']['_id']}    ${reservation_id}
    IF    'status' in ${status_data}
        Should Be Equal    ${json_response['data']['status']}    ${status_data['status']}
    END
    RETURN    ${response}

Delete Reservation
    [Documentation]    Remove reserva (admin)
    [Arguments]    ${token}    ${reservation_id}
    Set Authorization Header    ${token}
    ${response}=    DELETE On Session    ${SESSION}    /reservations/${reservation_id}
    ...    headers=${AUTH_HEADERS}
    ...    expected_status=any
    RETURN    ${response}

Delete Reservation Successfully
    [Documentation]    Remove reserva com sucesso
    [Arguments]    ${token}    ${reservation_id}
    ${response}=    Delete Reservation    ${token}    ${reservation_id}
    ${json_response}=    Validate Response Structure    ${response}    200
    Should Be True    ${json_response['success']}
    Should Contain    ${json_response}    message
    RETURN    ${response}

Generate Reservation Data
    [Documentation]    Gera dados para reserva
    [Arguments]    ${session_id}
    @{seats}=    Create List
    &{seat1}=    Create Dictionary    row=A    number=1    type=full
    &{seat2}=    Create Dictionary    row=A    number=2    type=full
    Append To List    ${seats}    ${seat1}
    Append To List    ${seats}    ${seat2}
    
    &{reservation_data}=    Create Dictionary
    ...    session=${session_id}
    ...    seats=${seats}
    ...    paymentMethod=credit_card
    
    RETURN    &{reservation_data}

Validate Reservation Error
    [Documentation]    Valida erro na criação de reserva
    [Arguments]    ${response}    ${expected_status}=400
    Should Be Equal As Integers    ${response.status_code}    ${expected_status}
    ${json_response}=    Set Variable    ${response.json()}
    Should Not Be True    ${json_response['success']}

Validate Seats Already Taken
    [Documentation]    Valida erro de assentos já ocupados
    [Arguments]    ${response}
    Should Be Equal As Integers    ${response.status_code}    400
    ${json_response}=    Set Variable    ${response.json()}
    Should Not Be True    ${json_response['success']}
    Should Contain    ${json_response['message']}    already taken    ignore_case=True