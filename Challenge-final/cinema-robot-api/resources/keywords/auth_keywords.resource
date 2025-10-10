*** Settings ***
Documentation    Keywords para testes de autenticação
Resource         ../base.resource

*** Keywords ***
Register New User
    [Documentation]    Registra um novo usuário
    [Arguments]    ${user_data}
    ${response}=    POST On Session    ${SESSION}    /auth/register
    ...    json=${user_data}
    ...    headers=${HEADERS}
    ...    expected_status=any
    RETURN    ${response}

Register User Successfully
    [Documentation]    Registra usuário com sucesso
    [Arguments]    ${user_data}
    ${response}=    Register New User    ${user_data}
    ${json_response}=    Validate Response Structure    ${response}    201
    Should Be True    ${json_response['success']}
    Should Contain    ${json_response}    data
    Should Contain    ${json_response['data']}    token
    Should Contain    ${json_response['data']}    _id
    Should Be Equal    ${json_response['data']['email']}    ${user_data['email']}
    Should Be Equal    ${json_response['data']['name']}    ${user_data['name']}
    RETURN    ${response}

Login User
    [Documentation]    Realiza login do usuário
    [Arguments]    ${email}    ${password}
    &{login_data}=    Create Dictionary    email=${email}    password=${password}
    ${response}=    POST On Session    ${SESSION}    /auth/login
    ...    json=${login_data}
    ...    headers=${HEADERS}
    ...    expected_status=any
    RETURN    ${response}

Login User Successfully
    [Documentation]    Realiza login com sucesso
    [Arguments]    ${email}    ${password}
    ${response}=    Login User    ${email}    ${password}
    ${json_response}=    Validate Response Structure    ${response}    200
    Should Be True    ${json_response['success']}
    Should Contain    ${json_response}    data
    Should Contain    ${json_response['data']}    token
    ${token}=    Extract Token From Response    ${response}
    RETURN    ${token}

Get User Profile
    [Documentation]    Obtém perfil do usuário logado
    [Arguments]    ${token}
    Set Authorization Header    ${token}
    ${response}=    GET On Session    ${SESSION}    /auth/me
    ...    headers=${AUTH_HEADERS}
    ...    expected_status=any
    RETURN    ${response}

Get User Profile Successfully
    [Documentation]    Obtém perfil com sucesso
    [Arguments]    ${token}
    ${response}=    Get User Profile    ${token}
    ${json_response}=    Validate Response Structure    ${response}    200
    Should Be True    ${json_response['success']}
    Should Contain    ${json_response}    data
    Should Contain    ${json_response['data']}    _id
    Should Contain    ${json_response['data']}    name
    Should Contain    ${json_response['data']}    email
    Should Contain    ${json_response['data']}    role
    RETURN    ${response}

Update User Profile
    [Documentation]    Atualiza perfil do usuário
    [Arguments]    ${token}    ${profile_data}
    Set Authorization Header    ${token}
    ${response}=    PUT On Session    ${SESSION}    /auth/profile
    ...    json=${profile_data}
    ...    headers=${AUTH_HEADERS}
    ...    expected_status=any
    RETURN    ${response}

Update User Profile Successfully
    [Documentation]    Atualiza perfil com sucesso
    [Arguments]    ${token}    ${profile_data}
    ${response}=    Update User Profile    ${token}    ${profile_data}
    ${json_response}=    Validate Response Structure    ${response}    200
    Should Be True    ${json_response['success']}
    Should Contain    ${json_response}    data
    IF    'name' in ${profile_data}
        Should Be Equal    ${json_response['data']['name']}    ${profile_data['name']}
    END
    RETURN    ${response}

Validate Registration Error
    [Documentation]    Valida erro de registro
    [Arguments]    ${response}    ${expected_message}
    Should Be Equal As Integers    ${response.status_code}    400
    ${json_response}=    Set Variable    ${response.json()}
    Should Not Be True    ${json_response['success']}
    Should Contain    ${json_response['message']}    ${expected_message}

Validate Login Error
    [Documentation]    Valida erro de login
    [Arguments]    ${response}    ${expected_status}=400
    Should Be Equal As Integers    ${response.status_code}    ${expected_status}
    ${json_response}=    Set Variable    ${response.json()}
    Should Not Be True    ${json_response['success']}

Validate Unauthorized Access
    [Documentation]    Valida acesso não autorizado
    [Arguments]    ${response}
    Should Be Equal As Integers    ${response.status_code}    401
    ${json_response}=    Set Variable    ${response.json()}
    Should Not Be True    ${json_response['success']}