*** Settings ***
Documentation        Elementos e ações da página de detalhes do filme

Resource       ../base.resource

*** Variables ***
# Seletores da página de detalhes
${MOVIE_DETAILS_CONTAINER}        css=.movie-details-container
${MOVIE_POSTER_DETAIL}            css=.movie-poster-detail img
${MOVIE_TITLE_DETAIL}             css=.movie-title-detail
${MOVIE_SYNOPSIS}                 css=.movie-synopsis
${MOVIE_DIRECTOR}                 css=.movie-director
${MOVIE_CAST}                     css=.movie-cast
${MOVIE_RELEASE_DATE_DETAIL}      css=.movie-release-date-detail
${MOVIE_DURATION_DETAIL}          css=.movie-duration-detail
${MOVIE_CLASSIFICATION_DETAIL}    css=.movie-classification-detail
${MOVIE_GENRES_DETAIL}            css=.movie-genres-detail
${SESSIONS_SECTION}               css=.sessions-section
${SESSION_CARD}                   css=.session-card
${SESSION_TIME}                   css=.session-time
${SESSION_DATE}                   css=.session-date
${SESSION_THEATER}                css=.session-theater
${SESSION_PRICE}                  css=.session-price
${RESERVE_BUTTON}                 css=.reserve-button
${BACK_BUTTON}                    css=.back-button

*** Keywords ***
Aguardar Carregamento da Página de Detalhes
    [Documentation]    Aguarda o carregamento completo da página de detalhes
    # Tenta diferentes seletores para a página de detalhes
    TRY
        Wait For Elements State    ${MOVIE_DETAILS_CONTAINER}    visible    10
    EXCEPT
        TRY
            Wait For Elements State    css=.movie-detail    visible    10
        EXCEPT
            TRY
                Wait For Elements State    css=.movie-info    visible    10
            EXCEPT
                # Verifica se pelo menos mudou de página
                ${current_url}=    Get Url
                Should Contain Any    ${current_url}    /movie    /film    /details
            END
        END
    END
    Wait For Load State    networkidle

Verificar Informações Básicas do Filme
    [Documentation]    Verifica se as informações básicas do filme estão presentes
    
    # Verifica pôster
    Wait For Elements State      ${MOVIE_POSTER_DETAIL}    visible    5
    
    # Verifica título
    Wait For Elements State      ${MOVIE_TITLE_DETAIL}     visible    5
    ${title}=    Get Text        ${MOVIE_TITLE_DETAIL}
    Should Not Be Empty          ${title}
    
    # Verifica sinopse
    Wait For Elements State      ${MOVIE_SYNOPSIS}         visible    5
    ${synopsis}=    Get Text     ${MOVIE_SYNOPSIS}
    Should Not Be Empty          ${synopsis}
    Should Be True               len($synopsis) > 20       Sinopse muito curta

Verificar Informações Detalhadas
    [Documentation]    Verifica informações detalhadas como diretor, elenco, etc.
    
    # Verifica diretor
    Wait For Elements State       ${MOVIE_DIRECTOR}        visible    5
    ${director}=    Get Text      ${MOVIE_DIRECTOR}
    Should Not Be Empty           ${director}
    
    # Verifica data de lançamento
    Wait For Elements State    ${MOVIE_RELEASE_DATE_DETAIL}    visible    5
    ${release_date}=           Get Text            ${MOVIE_RELEASE_DATE_DETAIL}
    Should Not Be Empty        ${release_date}
    
    # Verifica duração
    Wait For Elements State               ${MOVIE_DURATION_DETAIL}    visible    5
    ${duration}=           Get Text       ${MOVIE_DURATION_DETAIL}
    Should Not Be Empty    ${duration}
    Should Contain         ${duration}    min
    
    # Verifica classificação
    Wait For Elements State    ${MOVIE_CLASSIFICATION_DETAIL}    visible    5
    
    # Verifica gêneros
    Wait For Elements State    ${MOVIE_GENRES_DETAIL}    visible    5

Verificar Elenco
    [Documentation]    Verifica se o elenco está presente (se disponível)
    ${cast_exists}=    Run Keyword And Return Status    
    ...    Wait For Elements State    ${MOVIE_CAST}    visible    2
    
    IF    ${cast_exists}
        ${cast}=    Get Text    ${MOVIE_CAST}
        Should Not Be Empty     ${cast}
    END

Verificar Seção de Sessões
    [Documentation]    Verifica se a seção de horários de sessões está presente
    Wait For Elements State    ${SESSIONS_SECTION}     visible    5
    
    ${sessions_title}=         Get Text             ${SESSIONS_SECTION} >> h3
    Should Contain             ${sessions_title}    Horários    ignore_case=True

Verificar Cards de Sessões
    [Documentation]    Verifica se há cards de sessões disponíveis
    ${session_cards}=     Get Elements    ${SESSION_CARD}
    ${sessions_count}=    Get Length      ${session_cards}
    
    IF    ${sessions_count} > 0
        Log    Encontradas ${sessions_count} sessões disponíveis
        Verificar Elementos da Sessão    0
    ELSE
        Log    Nenhuma sessão disponível para este filme
    END

Verificar Elementos da Sessão
    [Documentation]    Verifica elementos de uma sessão específica
    [Arguments]    ${session_index}=0
    
    ${session_cards}=    Get Elements    ${SESSION_CARD}
    ${session}=          Set Variable    ${session_cards}[${session_index}]
    
    # Verifica horário
    Wait For Elements State    ${session} >> ${SESSION_TIME}    visible    5
    ${time}=                   Get Text    ${session} >> ${SESSION_TIME}
    Should Not Be Empty        ${time}
    
    # Verifica data
    Wait For Elements State    ${session} >> ${SESSION_DATE}    visible    5
    ${date}=    Get Text       ${session} >> ${SESSION_DATE}
    Should Not Be Empty        ${date}
    
    # Verifica teatro/sala
    Wait For Elements State    ${session} >> ${SESSION_THEATER}    visible    5
    ${theater}=    Get Text    ${session} >> ${SESSION_THEATER}
    Should Not Be Empty        ${theater}

Verificar Preços da Sessão
    [Documentation]    Verifica se os preços estão exibidos
    [Arguments]    ${session_index}=0
    
    ${session_cards}=    Get Elements    ${SESSION_CARD}
    ${session}=          Set Variable    ${session_cards}[${session_index}]
    
    ${price_exists}=    Run Keyword And Return Status
    ...    Wait For Elements State    ${session} >> ${SESSION_PRICE}    visible    2
    
    IF    ${price_exists}
        ${price}=              Get Text    ${session} >> ${SESSION_PRICE}
        Should Not Be Empty    ${price}
        Should Contain Any     ${price}    R$    $    €
    END

Clicar em Reservar Sessão
    [Documentation]    Clica no botão de reservar de uma sessão
    [Arguments]    ${session_index}=0
    
    ${session_cards}=    Get Elements    ${SESSION_CARD}
    ${session}=          Set Variable    ${session_cards}[${session_index}]
    
    ${reserve_button}=    Get Element    ${session} >> ${RESERVE_BUTTON}
    Click                 ${reserve_button}

Verificar Navegação para Reserva
    [Documentation]    Verifica se a navegação para reserva funciona
    [Arguments]    ${session_index}=0
    
    Clicar em Reservar Sessão    ${session_index}
    
    # Aguarda redirecionamento (pode ser para login ou seleção de assentos)
    Sleep    2s
    ${current_url}=       Get Url
    Should Contain Any    ${current_url}    /login    /reservations    /seats

Voltar para Lista de Filmes
    [Documentation]    Clica no botão voltar ou navega de volta
    ${back_exists}=    Run Keyword And Return Status
    ...    Wait For Elements State    ${BACK_BUTTON}    visible    2
    
    IF    ${back_exists}
        Click    ${BACK_BUTTON}
    ELSE
        Go Back
    END
    
    Sleep    2s

Obter Título do Filme na Página de Detalhes
    [Documentation]    Obtém o título do filme na página de detalhes
    ${title}=    Get Text    ${MOVIE_TITLE_DETAIL}
    RETURN       ${title}