*** Settings ***
Documentation        Elementos e ações da página de sessões

Library        Browser
Resource       ../env.resource

*** Variables ***
# Seletores da página de sessões
${SESSIONS_CONTAINER}     css=.sessions-container
${SESSION_CARD}           css=.session-card
${SESSION_TIME}           css=.session-time
${SESSION_DATE}           css=.session-date
${SESSION_THEATER}        css=.session-theater
${SESSION_AVAILABILITY}   css=.session-availability
${SESSION_PRICE}          css=.session-price
${SELECT_SESSION_BTN}     css=.select-session-btn
${MOVIE_INFO}             css=.movie-info
${NO_SESSIONS_MESSAGE}    css=.no-sessions-message

*** Keywords ***
Aguardar Carregamento das Sessões
    [Documentation]    Aguarda o carregamento da página de sessões
    Wait For Elements State    ${SESSIONS_CONTAINER}    visible    10
    Wait For Load State        networkidle

Verificar Informações do Filme
    [Documentation]    Verifica se as informações do filme estão presentes
    Wait For Elements State    ${MOVIE_INFO}    visible    5
    ${movie_title}=    Get Text    ${MOVIE_INFO} >> css=h1
    Should Not Be Empty    ${movie_title}
    RETURN    ${movie_title}

Verificar Cards de Sessões Disponíveis
    [Documentation]    Verifica se há sessões disponíveis
    ${session_cards}=    Get Elements    ${SESSION_CARD}
    ${sessions_count}=    Get Length    ${session_cards}
    Should Be True    ${sessions_count} > 0    Nenhuma sessão disponível
    RETURN    ${session_cards}

Verificar Elementos da Sessão
    [Documentation]    Verifica elementos de uma sessão específica
    [Arguments]    ${session_index}=0
    
    ${session_cards}=    Get Elements    ${SESSION_CARD}
    ${session}=    Set Variable    ${session_cards}[${session_index}]
    
    # Verifica horário
    Wait For Elements State    ${session} >> ${SESSION_TIME}    visible    5
    ${time}=    Get Text    ${session} >> ${SESSION_TIME}
    Should Not Be Empty    ${time}
    
    # Verifica data
    Wait For Elements State    ${session} >> ${SESSION_DATE}    visible    5
    ${date}=    Get Text    ${session} >> ${SESSION_DATE}
    Should Not Be Empty    ${date}
    
    # Verifica teatro
    Wait For Elements State    ${session} >> ${SESSION_THEATER}    visible    5
    ${theater}=    Get Text    ${session} >> ${SESSION_THEATER}
    Should Not Be Empty    ${theater}
    
    # Verifica disponibilidade
    ${availability_exists}=    Run Keyword And Return Status
    ...    Wait For Elements State    ${session} >> ${SESSION_AVAILABILITY}    visible    2
    
    IF    ${availability_exists}
        ${availability}=    Get Text    ${session} >> ${SESSION_AVAILABILITY}
        Should Not Be Empty    ${availability}
    END

Selecionar Sessão
    [Documentation]    Seleciona uma sessão específica
    [Arguments]    ${session_index}=0
    
    ${session_cards}=    Get Elements    ${SESSION_CARD}
    ${session}=    Set Variable    ${session_cards}[${session_index}]
    ${select_btn}=    Get Element    ${session} >> ${SELECT_SESSION_BTN}
    Click    ${select_btn}
    Wait For Load State    networkidle

Navegar para Página de Sessões
    [Documentation]    Navega para página de sessões de um filme
    [Arguments]    ${movie_id}=1
    Go To    ${BASE_URL}/movies/${movie_id}/sessions
    Aguardar Carregamento das Sessões