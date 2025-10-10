*** Settings ***
Documentation        Elementos e ações da página inicial (Home)

Resource       ../base.resource


*** Keywords ***
Confirme elementos home
    [Documentation]    Verifica se todos os elementos principais da home estão presentes
    
    # Título principal
    Wait For Elements State    css=.home-container h1 >> text=Welcome to Cinema App    visible    5
    
    # Subtítulo
    Wait For Elements State    css=.home-container p >> text=Your premier destination for movie tickets and information    visible    5
    
    # Seção de funcionalidades
    Wait For Elements State    css=.features-section h2 >> text=Available Features    visible    5
    Wait For Elements State    css=.features-section ul    visible    5
    
    # Botão CTA principal
    Wait For Elements State    css=.cta-buttons a[href="/movies"]    visible    5
    
    # Seção de filmes em cartaz
    Wait For Elements State    css=.featured-movies h2 >> text=Filmes em Cartaz    visible    5
    Wait For Elements State    css=.movie-grid    visible    10
    
    # Seção Coming Soon
    Wait For Elements State    css=.coming-soon h2 >> text=Coming Soon    visible    5

Verificar Link Principal de Filmes
    [Documentation]    Verifica se o link principal para filmes funciona
    
    ${link_element}=    Get Element    css=.cta-buttons a[href="/movies"]
    ${link_text}=    Get Text    ${link_element}
    Should Be Equal    ${link_text}    Ver todos os filmes em cartaz
    
    ${href}=    Get Attribute    ${link_element}    href
    Should Contain    ${href}    /movies

Verificar Cards de Filmes
    [Documentation]    Verifica se os cards de filmes estão presentes
    
    Aguardar Carregamento dos Filmes
    
    # Verifica se há cards de filmes
    Wait For Elements State    css=.movie-grid    visible    5
    ${movie_cards}=    Get Elements    css=.movie-card
    ${cards_count}=    Get Length    ${movie_cards}
    Should Be True    ${cards_count} > 0    Nenhum card de filme encontrado
    RETURN    ${movie_cards}

Aguardar Carregamento dos Filmes
    [Documentation]    Aguarda o carregamento dos filmes (spinner desaparecer)
    
    ${loading_exists}=    Run Keyword And Return Status
    ...    Wait For Elements State    css=.loading-container    visible    2
    
    IF    ${loading_exists}
        Wait For Elements State    css=.loading-container    hidden    15
    END

Clicar Link Ver Todos os Filmes
    [Documentation]    Clica no link principal para ver todos os filmes
    
    Click    css=.cta-buttons a[href="/movies"]
    Wait For Load State    networkidle

Clicar Primeiro Card de Filme
    [Documentation]    Clica no primeiro card de filme disponível
    
    ${movie_cards}=    Verificar Cards de Filmes
    ${first_card}=    Set Variable    ${movie_cards}[0]
    
    ${detail_link_exists}=    Run Keyword And Return Status
    ...    Wait For Elements State    ${first_card} >> css=a    visible    2
    
    IF    ${detail_link_exists}
        ${detail_link}=    Get Element    ${first_card} >> css=a
        Click    ${detail_link}
        Sleep    2s
    ELSE
        Fail    Nenhum link encontrado no card de filme
    END

Verificar Responsividade da Home
    [Documentation]    Testa responsividade em diferentes tamanhos de tela
    
    # Desktop
    Set Viewport Size    1920    1080
    Wait For Elements State    css=.home-container    visible    5
    
    # Tablet
    Set Viewport Size    768    1024
    Wait For Elements State    css=.home-container    visible    5
    
    # Mobile
    Set Viewport Size    375    667
    Wait For Elements State    css=.home-container    visible    5

Obter Contagem de Cards de Filmes
    [Documentation]    Retorna a quantidade de cards de filmes na página
    
    Aguardar Carregamento dos Filmes
    ${movie_cards}=    Get Elements    css=.movie-card
    ${cards_count}=    Get Length    ${movie_cards}
    RETURN    ${cards_count}


