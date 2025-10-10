*** Settings ***
Documentation    Keywords para testes de usuários (admin)
Resource         ../base.resource

*** Keywords ***
Get All Users
    [Documentation]    Obtém lista de todos os usuários (admin)
    [Arguments]    ${token}    ${params}=${EMPTY}
    Set Authorization Header    ${token}
    ${response}=    GET On Session    ${SESSION}    /users
    ...    params=${params}
    ...    headers=${AUTH_HEADERS}
    ...    expected_status=any
    RETURN    ${response}

Get All Users Successfully
    [Documentation]    Obtém lista de usuários com sucesso
    [Arguments]    ${token}    ${params}=${EMPTY}
    ${response}=    Get All Users    ${token}    ${params}
    ${json_response}=    Validate Response Structure    ${response}    200
    Should Be True    ${json_response['success']}
    Should Contain    ${json_response}    count
    Should Contain    ${json_response}    data
    Should Contain    ${json_response}    pagination
    Should Be True    ${json_response['count']} >= 0
    RETURN    ${response}

Get User By ID
    [Documentation]    Obtém usuário por ID (admin)
    [Arguments]    ${token}    ${user_id}
    Set Authorization Header    ${token}
    ${response}=    GET On Session    ${SESSION}    /users/${user_id}
    ...    headers=${AUTH_HEADERS}
    ...    expected_status=any
    RETURN    ${response}

Get User By ID Successfully
    [Documentation]    Obtém usuário por ID com sucesso
    [Arguments]    ${token}    ${user_id}
    ${response}=    Get User By ID    ${token}    ${user_id}
    ${json_response}=    Validate Response Structure    ${response}    200
    Should Be True    ${json_response['success']}
    Should Contain    ${json_response}    data
    Should Contain    ${json_response['data']}    _id
    Should Contain    ${json_response['data']}    name
    Should Contain    ${json_response['data']}    email
    Should Contain    ${json_response['data']}    role
    Should Be Equal    ${json_response['data']['_id']}    ${user_id}
    RETURN    ${response}

Update User
    [Documentation]    Atualiza usuário (admin)
    [Arguments]    ${token}    ${user_id}    ${user_data}
    Set Authorization Header    ${token}
    ${response}=    PUT On Session    ${SESSION}    /users/${user_id}
    ...    json=${user_data}
    ...    headers=${AUTH_HEADERS}
    ...    expected_status=any
    RETURN    ${response}

Update User Successfully
    [Documentation]    Atualiza usuário com sucesso
    [Arguments]    ${token}    ${user_id}    ${user_data}
    ${response}=    Update User    ${token}    ${user_id}    ${user_data}
    ${json_response}=    Validate Response Structure    ${response}    200
    Should Be True    ${json_response['success']}
    Should Contain    ${json_response}    data
    Should Be Equal    ${json_response['data']['_id']}    ${user_id}
    IF    'name' in ${user_data}
        Should Be Equal    ${json_response['data']['name']}    ${user_data['name']}
    END
    IF    'role' in ${user_data}
        Should Be Equal    ${json_response['data']['role']}    ${user_data['role']}
    END
    RETURN    ${response}

Delete User
    [Documentation]    Remove usuário (admin)
    [Arguments]    ${token}    ${user_id}
    Set Authorization Header    ${token}
    ${response}=    DELETE On Session    ${SESSION}    /users/${user_id}
    ...    headers=${AUTH_HEADERS}
    ...    expected_status=any
    RETURN    ${response}

Delete User Successfully
    [Documentation]    Remove usuário com sucesso
    [Arguments]    ${token}    ${user_id}
    ${response}=    Delete User    ${token}    ${user_id}
    ${json_response}=    Validate Response Structure    ${response}    200
    Should Be True    ${json_response['success']}
    Should Contain    ${json_response}    message
    RETURN    ${response}

Filter Users By Role
    [Documentation]    Filtra usuários por função
    [Arguments]    ${token}    ${role}
    &{params}=    Create Dictionary    role=${role}
    ${response}=    Get All Users Successfully    ${token}    ${params}
    ${json_response}=    Set Variable    ${response.json()}
    FOR    ${user}    IN    @{json_response['data']}
        Should Be Equal    ${user['role']}    ${role}
    END
    RETURN    ${response}

Validate User Not Found
    [Documentation]    Valida erro de usuário não encontrado
    [Arguments]    ${response}
    Should Be Equal As Integers    ${response.status_code}    404
    ${json_response}=    Set Variable    ${response.json()}
    Should Not Be True    ${json_response['success']}
    Should Contain    ${json_response['message']}    not found    ignore_case=True

Validate Email Already In Use
    [Documentation]    Valida erro de email já em uso
    [Arguments]    ${response}
    Should Be Equal As Integers    ${response.status_code}    409
    ${json_response}=    Set Variable    ${response.json()}
    Should Not Be True    ${json_response['success']}
    Should Contain    ${json_response['message']}    already in use    ignore_case=True

Validate Cannot Delete User With Reservations
    [Documentation]    Valida erro ao tentar deletar usuário com reservas
    [Arguments]    ${response}
    Should Be Equal As Integers    ${response.status_code}    409
    ${json_response}=    Set Variable    ${response.json()}
    Should Not Be True    ${json_response['success']}
    Should Contain    ${json_response['message']}    reservations    ignore_case=True

Test Pagination
    [Documentation]    Testa paginação da lista de usuários
    [Arguments]    ${token}
    # Primeira página
    &{params1}=    Create Dictionary    page=1    limit=2
    ${response1}=    Get All Users Successfully    ${token}    ${params1}
    ${json1}=    Set Variable    ${response1.json()}
    
    # Verifica estrutura de paginação
    Should Contain    ${json1}    pagination
    Should Be Equal As Integers    ${json1['pagination']['page']}    1
    Should Be Equal As Integers    ${json1['pagination']['limit']}    2
    
    # Se há mais de 2 usuários, testa segunda página
    IF    ${json1['count']} > 2
        &{params2}=    Create Dictionary    page=2    limit=2
        ${response2}=    Get All Users Successfully    ${token}    ${params2}
        ${json2}=    Set Variable    ${response2.json()}
        Should Be Equal As Integers    ${json2['pagination']['page']}    2
    END