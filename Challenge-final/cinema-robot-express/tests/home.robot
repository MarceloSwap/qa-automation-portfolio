*** Settings ***
Documentation       Testes da página inicial (Home)

Resource    ../resources/base.resource

Test Setup       Start Session
Test Teardown    Take Screenshot

*** Test Cases ***
CT-Home-001 Página Inicial Atrativa
    [Documentation]    Verifica se a página inicial contém todos os elementos principais
    
    Confirme elementos home

CT-Home-002 Deve exibir link para ver todos os filmes
    [Documentation]    Verifica se o link "Ver todos os filmes em cartaz" está presente e funcional
    
    Verificar Link Principal de Filmes
    Clicar Link Ver Todos os Filmes
    ${current_url}=    Get Url
    Should Contain    ${current_url}    /movies

CT-Home-003 Deve exibir seção de filmes em cartaz
    [Documentation]    Verifica se a seção "Filmes em Cartaz" está presente
    
    Wait For Elements State    css=.featured-movies h2 >> text=Filmes em Cartaz    visible    5
    Wait For Elements State    css=.movie-grid    visible    10

CT-Home-004 Deve exibir cards de filmes com links
    [Documentation]    Verifica se os cards de filmes contêm links para detalhes
    
    ${movie_cards}=    Verificar Cards de Filmes
    
    # Verifica se o primeiro card tem link para detalhes
    ${first_card}=    Set Variable    ${movie_cards}[0]
    ${detail_links}=    Get Elements    ${first_card} >> css=a
    ${links_count}=    Get Length    ${detail_links}
    Should Be True    ${links_count} > 0    Card de filme não contém links

CT-Home-005 Deve carregar filmes da API ou exibir filmes locais
    [Documentation]    Verifica se os filmes são carregados da API ou exibe filmes locais como fallback
    
    ${cards_count}=    Obter Contagem de Cards de Filmes
    Should Be True    ${cards_count} >= 3    Deve exibir pelo menos 3 filmes

CT-Home-006 Deve exibir seção de funcionalidades
    [Documentation]    Verifica se a seção "Available Features" está presente
    
    Wait For Elements State    css=.features-section h2 >> text=Available Features    visible    5
    Wait For Elements State    css=.features-section ul    visible    5
    
    # Verifica se há pelo menos 5 funcionalidades listadas
    ${features}=    Get Elements    css=.features-section ul li
    ${features_count}=    Get Length    ${features}
    Should Be True    ${features_count} >= 5    Deve listar pelo menos 5 funcionalidades

CT-Home-007 Deve exibir seção Coming Soon
    [Documentation]    Verifica se a seção "Coming Soon" está presente
    
    Wait For Elements State    css=.coming-soon h2 >> text=Coming Soon    visible    5
    Wait For Elements State    css=.coming-soon p    visible    5

CT-Home-008 Links dos cards devem navegar para detalhes
    [Documentation]    Verifica se os links dos cards de filmes navegam corretamente
    
    Clicar Primeiro Card de Filme
    ${current_url}=    Get Url
    Should Contain    ${current_url}    /movies

CT-Home-009 Deve ser responsiva
    [Documentation]    Verifica se a página se adapta a diferentes tamanhos de tela
    
    # Testa em desktop
    Set Viewport Size    1920    1080
    Sleep    1s
    Confirme elementos home
    
    # Testa em tablet
    Set Viewport Size    768    1024
    Sleep    1s
    Confirme elementos home
    
    # Testa em mobile
    Set Viewport Size    375    667
    Sleep    1s
    Confirme elementos home

CT-Home-010 Deve lidar com erro de carregamento
    [Documentation]    Verifica se a página funciona mesmo com erro na API
    
    ${cards_count}=    Obter Contagem de Cards de Filmes
    Should Be True    ${cards_count} >= 3    Deve exibir filmes locais como fallback
