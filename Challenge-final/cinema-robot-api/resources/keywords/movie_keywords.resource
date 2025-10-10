*** Settings ***
Documentation    Keywords para testes de filmes
Resource         ../base.resource

*** Keywords ***
Get All Movies
    [Documentation]    Obtém lista de todos os filmes
    [Arguments]    ${params}=${EMPTY}
    ${response}=    GET On Session    ${SESSION}    /movies
    ...    params=${params}
    ...    headers=${HEADERS}
    ...    expected_status=any
    RETURN    ${response}

Get All Movies Successfully
    [Documentation]    Obtém lista de filmes com sucesso
    [Arguments]    ${params}=${EMPTY}
    ${response}=    Get All Movies    ${params}
    ${json_response}=    Validate Response Structure    ${response}    200
    Should Contain    ${json_response}    data
    Should Contain    ${json_response}    count
    Should Be True    ${json_response['count']} >= 0
    RETURN    ${response}

Get Movie By ID
    [Documentation]    Obtém filme por ID
    [Arguments]    ${movie_id}
    ${response}=    GET On Session    ${SESSION}    /movies/${movie_id}
    ...    headers=${HEADERS}
    ...    expected_status=any
    RETURN    ${response}

Get Movie By ID Successfully
    [Documentation]    Obtém filme por ID com sucesso
    [Arguments]    ${movie_id}
    ${response}=    Get Movie By ID    ${movie_id}
    ${json_response}=    Validate Response Structure    ${response}    200
    Should Be True    ${json_response['success']}
    Should Contain    ${json_response}    data
    Should Contain    ${json_response['data']}    _id
    Should Contain    ${json_response['data']}    title
    Should Contain    ${json_response['data']}    synopsis
    Should Contain    ${json_response['data']}    director
    Should Contain    ${json_response['data']}    genres
    Should Contain    ${json_response['data']}    duration
    Should Contain    ${json_response['data']}    classification
    Should Be Equal    ${json_response['data']['_id']}    ${movie_id}
    RETURN    ${response}

Create Movie
    [Documentation]    Cria um novo filme (admin)
    [Arguments]    ${token}    ${movie_data}
    Set Authorization Header    ${token}
    ${response}=    POST On Session    ${SESSION}    /movies
    ...    json=${movie_data}
    ...    headers=${AUTH_HEADERS}
    ...    expected_status=any
    RETURN    ${response}

Create Movie Successfully
    [Documentation]    Cria filme com sucesso
    [Arguments]    ${token}    ${movie_data}
    ${response}=    Create Movie    ${token}    ${movie_data}
    ${json_response}=    Validate Response Structure    ${response}    201
    Should Be True    ${json_response['success']}
    Should Contain    ${json_response}    data
    Should Contain    ${json_response['data']}    _id
    Should Be Equal    ${json_response['data']['title']}    ${movie_data['title']}
    Should Be Equal    ${json_response['data']['director']}    ${movie_data['director']}
    Should Be Equal As Numbers    ${json_response['data']['duration']}    ${movie_data['duration']}
    RETURN    ${response}

Update Movie
    [Documentation]    Atualiza filme existente (admin)
    [Arguments]    ${token}    ${movie_id}    ${movie_data}
    Set Authorization Header    ${token}
    ${response}=    PUT On Session    ${SESSION}    /movies/${movie_id}
    ...    json=${movie_data}
    ...    headers=${AUTH_HEADERS}
    ...    expected_status=any
    RETURN    ${response}

Update Movie Successfully
    [Documentation]    Atualiza filme com sucesso
    [Arguments]    ${token}    ${movie_id}    ${movie_data}
    ${response}=    Update Movie    ${token}    ${movie_id}    ${movie_data}
    ${json_response}=    Validate Response Structure    ${response}    200
    Should Be True    ${json_response['success']}
    Should Contain    ${json_response}    data
    Should Be Equal    ${json_response['data']['_id']}    ${movie_id}
    IF    'title' in ${movie_data}
        Should Be Equal    ${json_response['data']['title']}    ${movie_data['title']}
    END
    RETURN    ${response}

Delete Movie
    [Documentation]    Remove filme (admin)
    [Arguments]    ${token}    ${movie_id}
    Set Authorization Header    ${token}
    ${response}=    DELETE On Session    ${SESSION}    /movies/${movie_id}
    ...    headers=${AUTH_HEADERS}
    ...    expected_status=any
    RETURN    ${response}

Delete Movie Successfully
    [Documentation]    Remove filme com sucesso
    [Arguments]    ${token}    ${movie_id}
    ${response}=    Delete Movie    ${token}    ${movie_id}
    ${json_response}=    Validate Response Structure    ${response}    200
    Should Be True    ${json_response['success']}
    Should Contain    ${json_response}    message
    RETURN    ${response}

Validate Movie Not Found
    [Documentation]    Valida erro de filme não encontrado
    [Arguments]    ${response}
    Should Be Equal As Integers    ${response.status_code}    404
    ${json_response}=    Set Variable    ${response.json()}
    Should Not Be True    ${json_response['success']}
    Should Contain    ${json_response['message']}    not found

Validate Invalid Movie ID
    [Documentation]    Valida erro de ID inválido
    [Arguments]    ${response}
    Should Be Equal As Integers    ${response.status_code}    400
    ${json_response}=    Set Variable    ${response.json()}
    Should Not Be True    ${json_response['success']}

Validate Admin Required
    [Documentation]    Valida que acesso admin é necessário
    [Arguments]    ${response}
    Should Be Equal As Integers    ${response.status_code}    403
    ${json_response}=    Set Variable    ${response.json()}
    Should Not Be True    ${json_response['success']}

Search Movies By Title
    [Documentation]    Busca filmes por título
    [Arguments]    ${title}
    &{params}=    Create Dictionary    title=${title}
    ${response}=    Get All Movies Successfully    ${params}
    ${json_response}=    Set Variable    ${response.json()}
    FOR    ${movie}    IN    @{json_response['data']}
        Should Contain    ${movie['title']}    ${title}    ignore_case=True
    END
    RETURN    ${response}

Search Movies By Genre
    [Documentation]    Busca filmes por gênero
    [Arguments]    ${genre}
    &{params}=    Create Dictionary    genre=${genre}
    ${response}=    Get All Movies Successfully    ${params}
    ${json_response}=    Set Variable    ${response.json()}
    FOR    ${movie}    IN    @{json_response['data']}
        Should Contain    ${movie['genres']}    ${genre}
    END
    RETURN    ${response}