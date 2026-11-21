-- Dialogos dos NPCs da vila. Cada NPC tem varias conversas (listas de paginas); a cada nova
-- conversa com o mesmo NPC o cliente avanca para a proxima, em ciclo.

local D = {}

D.tobias = {
	{
		"Quarenta anos arando esta terra, e nunca a vi assim. Rachou como couro velho. Enfio a enxada e ela volta sem um grão de umidade.",
		"Semeamos duas vezes neste ano. Duas vezes o broto nasceu e secou antes de ficar da altura de um dedo.",
		"Continuo vindo. Não sei mais para quê. Se eu parar, terei de admitir que acabou.",
	},
	{
		"O poço de cima já deu água barrenta. Agora dá só lama e um cheiro que não me agrada.",
		"Meu filho achava que bastava cavar mais fundo. Está enterrado perto do muro desde a primavera.",
	},
}

D.heitor = {
	{
		"Não pergunte para quem é a cova. Nesta semana já são cinco, e ainda é quarta-feira.",
		"Antes eu cavava uma por mês e sobrava tempo para a cerveja. Agora a terra mole acaba, e eu cavo onde ainda dá.",
		"Dizem que é a febre. Eu digo que é a fome, que veste a febre como roupa emprestada.",
	},
	{
		"As covas das crianças são as mais curtas. Cavo-as mais depressa, e é isso que me assusta.",
		"O frade reza por todos. Eu só garanto que ninguém fique sem lugar.",
	},
}

D.gaspar = {
	{
		"Servi ao senhor destas terras por dezoito anos. Esta perna ficou numa estrada que já nem existe. Tem um pão velho, viajante?",
		"Não? Também não esperava. Ninguém tem. O padeiro vende ar e promessa.",
		"Se o dinheiro ainda comprasse alguma coisa, eu pediria dinheiro.",
	},
	{
		"De noite, quando os lampiões piscam, finjo que são fogueiras de acampamento. Ajuda a dormir.",
		"Já vi exércitos famintos. Mas um exército marcha para algum lugar. Aqui a fome só fica sentada.",
	},
}

D.leonidas = {
	{
		"Que a paz esteja convosco, ainda que a paz tenha deixado esta vila. Rezo junto à fonte porque é o que nos resta de água benta.",
		"Os sinos dobraram tantas vezes por finados que o povo deixou de levantar a cabeça ao ouvi-los.",
		"Peço perdão a cada mão que se estende para mim esperando um pão que não tenho.",
	},
	{
		"Perguntam-me se Deus nos abandonou. Respondo que Ele ainda ouve. O que mudou foi o que lhe pedimos: já não pedimos colheita, pedimos só amanhecer.",
	},
}

D.cassio = {
	{
		"Barraca aberta, bancas vazias. Faço isto por costume, e porque porta fechada é pior que banca vazia.",
		"Ontem vendi uma maçã por três vezes o que valia. O comprador chorou ao pagar. Eu também.",
		"Antes havia gritaria de feira. Agora só se ouve o vento nas lonas.",
	},
	{
		"Os carroceiros pararam de vir. O que mais pesa é que ninguém pergunta mais o preço. Todos só olham.",
		"Guardo estas caixas porque, se um dia chegar mercadoria, quero ter onde pô-la.",
	},
}

D.rufino = {
	{
		"Alto. Ah, é você. Pouco me importa quem passa: ninguém tem o que roubar, e eu não tenho forças para correr atrás.",
		"Os guardas dividem uma maçã por turno. Ontem eu fiquei com o miolo.",
		"Dizem que o senhor trancou o celeiro. Não sei se é verdade. Prefiro não saber.",
	},
	{
		"A muralha foi feita para manter inimigos do lado de fora. Agora só serve para manter a fome do lado de dentro.",
	},
}

D.marta = {
	{
		"Não... não precisa dizer nada. Todos dizem 'sinto muito' e todos desviam o rosto.",
		"Meu Jonas saiu para buscar água no riacho da colina. Voltaram só com o balde.",
		"Venho rezar junto à fonte. Quando ela falha, penso que até a água se cansou de nós.",
	},
	{
		"Ainda tenho dois filhos. Dou-lhes a minha parte da sopa dizendo que já comi. Eles fingem acreditar.",
	},
}

D.eulalia = {
	{
		"Se está doente, não posso ajudar. Se está só cansado, também não. As ervas secaram antes dos doentes.",
		"Atendi nove casas esta semana. Em quatro, cheguei tarde. Em duas, o doente pediu que eu levasse a comida para outro.",
		"Pergunta o que cura? Pão, água limpa e descanso. Nenhum dos três eu consigo receitar.",
	},
	{
		"A febre vai de casa em casa como um cobrador. Só não pede nada que alguém ainda tenha.",
	},
}

D.berenice = {
	{
		"Lavo o que posso nesta bacia. A água vem turva, e o pano sai mais sujo do que entrou.",
		"Quase tudo que lavo agora é roupa de defunto. Os vivos guardam as suas para não gastar a pouca água.",
		"Se quiser, lavo suas mãos. Pelo menos isso a água ainda faz.",
	},
	{
		"A fonte falha e volta. Dizem que é presságio. Eu digo que é cano entupido e falta de quem conserte.",
	},
}

D.sidonia = {
	{
		"Meu forno está frio há trinta dias. Acendo uma brasa à noite para que a casa lembre que um dia cheirou a pão.",
		"Eu moía o trigo do velho Orlando. O moinho parou: sem grão, as pedras giram sozinhas, e o rangido dá dor de cabeça.",
		"Faço farinha de casca de árvore, raiz moída e esperança. Não alimenta, mas enche a mesa.",
	},
	{
		"Um menino roubou meu último pão. Corri atrás dele e, quando o alcancei, não tive coragem de tirá-lo.",
	},
}

D.ines = {
	{
		"Shhh... fale baixo. O pequeno finalmente dormiu. Há dias ele não chora; não tem força nem para isso.",
		"Dou-lhe água com um pouco de açúcar que guardei. É o último. Quando acabar, não sei o que invento.",
		"Olhe a fonte, ali. Jorra como se nada tivesse acontecido. Odeio vê-la tão bonita.",
	},
	{
		"Meu marido saiu há doze dias para procurar trabalho na cidade. Fico na porta, contando os lampiões, esperando um vulto.",
	},
}

D.albertina = {
	{
		"Remendo roupas de quem não vai mais precisar delas. Dizem que é prudência: o tecido passa adiante, o dono não.",
		"Meu fio acabou. Agora desfio as mantas velhas para fazer o fio das próximas.",
		"Se a vila encolhe, as roupas sobram. É a única riqueza que cresce por aqui.",
	},
	{
		"Cada vez que fecho um ponto, penso em quem vestiu aquilo. A lista é longa demais.",
	},
}

D.ludmila = {
	{
		"Varro a porta todo dia, embora ninguém venha. Uma taberna limpa e vazia é um luto com bons modos.",
		"Os barris secaram antes das moedas. O último vinho foi para o frade, para dar missa aos que partiam.",
		"Aqui os homens riam alto e contavam mentiras. Sinto falta das mentiras. Agora só se conta a verdade, e ela não tem graça.",
	},
	{
		"Se quiser sentar, a casa está aberta. Mas não tenho o que servir além de silêncio e um banco.",
	},
}

D.pedrinho = {
	{
		"Estou desenhando um pão. Está vendo? É grande, com casca dourada. Se eu desenhar bem, quem sabe aparece.",
		"Mamãe diz que desenhar não enche barriga, mas ajuda a distrair o barulho dela.",
		"Quer que eu desenhe um para você também?",
	},
	{
		"Ontem o Teco dormiu e não acordou. Falei com ele hoje, mas ele não respondeu. Será que está bravo comigo?",
	},
}

D.clarinha = {
	{
		"Essa é a Margarida. Ela não come desde ontem, mas é porque não quer, não é por falta.",
		"Eu conto histórias para ela dormir. A de hoje é sobre um rio que volta a correr.",
		"Você acha que o rio volta mesmo?",
	},
	{
		"Mamãe disse que, quando a fonte falhar de vez, vamos embora. Mas a Margarida não quer ir.",
	},
}

D.tome = {
	{
		"Busco água para a dona Berenice e ganho um gole. Hoje o poço já estava cercado de gente. Esperei até o céu escurecer.",
		"Se eu derramar, apanho. Se eu beber, também. Aprendi a andar bem devagar e a ter sede em silêncio.",
		"O balde pesa mais do que eu, mas é a única coisa que ainda me dá o que fazer.",
	},
	{
		"Eu tinha um irmão. Ele cuidava do balde antes de mim.",
	},
}

D.lia = {
	{
		"Procuro grãos que caíram dos sacos dos carroceiros. Às vezes acho um. Hoje achei três e uma pedra que parecia um.",
		"Cada grão eu guardo no bolso. Quando juntar o bastante, faço uma papa para minha irmã.",
		"Não conte aos outros onde procuro. Só eu sei os bons lugares.",
	},
	{
		"Pensei que fosse ouro, mas era só a luz do lampião numa pedra. Mesmo assim, guardei.",
	},
}

D.rosa = {
	{
		"Olhe o lampião, como ele treme. Dizem que, quando a luz some, alguém partiu.",
		"Eu conto as luzes das casas toda noite. Ontem eram menos. Hoje serão menos ainda.",
		"Tenho medo de que um dia eu conte e não sobre nenhuma.",
	},
	{
		"Vovó dizia que o escuro não faz mal, que mal faz quem some nele. Ela sumiu no inverno.",
	},
}

D.zeca = {
	{
		"Eu fico aqui porque dá para ver quem entra na vila. Antes entravam carroças. Agora só saem pessoas.",
		"O pai disse que vamos esperar a chuva. Ele diz isso desde a primavera, e a chuva também espera, só que sentada.",
		"Quando eu crescer, vou trazer água para todo mundo, de um rio bem grande.",
	},
	{
		"Se você achar um pedaço de pão, me conta? Divido com você, juro.",
	},
}

-- ===================== NOVOS NPCs COM FALA PROPRIA =====================
D.abel = {
	{
		"Toco o sino só quando alguém morre. Antes tocava para a missa, para a colheita, para o casamento. Agora o sino só conhece um som.",
		"Ontem toquei seis vezes antes do meio-dia. Parei de contar as badaladas e comecei a contar os nomes.",
		"As cordas do sino estão gastas. Não pelo vento. Pelo uso.",
	},
	{
		"Há quem me peça para não tocar quando for criança. Respondo que não toco mais alto, só mais devagar.",
	},
}

D.claudio = {
	{
		"Registro os nascimentos e as mortes no mesmo livro. Há cinco anos as páginas de nascimento estavam cheias. Agora só uso as outras.",
		"Cada nome que escrevo, escrevo com a minha melhor letra. É o único funeral que alguns terão.",
		"O papel também está acabando. Logo teremos de escolher quem merece ser lembrado.",
	},
	{
		"O senhor destas terras manda perguntar quantos restam. Respondo com um número. A cada semana o número encolhe, e ele já não responde.",
	},
}

D.valdemar = {
	{
		"A bigorna esfriou. Sem lenha não há forja, sem forja não há enxada, e sem enxada... o resto você já viu nos campos.",
		"Antes eu consertava arados. Agora só afio as pás do coveiro. É o único serviço que nunca falta.",
		"Dei meu último prego para escorar um caixão. Não me arrependo.",
	},
	{
		"Ferro não passa fome, mas enferruja. Eu me sinto como ele.",
	},
}

D.lazaro = {
	{
		"Pedir esmola numa vila onde todos pedem é como vender água no rio. Ainda assim, estendo a tigela. É o costume.",
		"Hoje alguém deixou um botão. Agradeci. O gesto é o que conta, mesmo que o botão não alimente.",
		"Durmo perto da fonte porque o som da água me engana. Por algumas horas, acredito que chove.",
	},
	{
		"Fui carpinteiro. Fiz a porta daquela casa, ali. Agora passo por ela e ninguém me reconhece.",
	},
}

D.dorotea = {
	{
		"Faz três meses que não nasce criança nesta vila. As mães não chegam ao fim da gestação, ou chegam sem leite.",
		"Antes eu era chamada de madrugada, com alegria. Agora me chamam de madrugada e peço a Deus que seja engano.",
		"Guardei meus panos limpos, mas não há quem os use.",
	},
	{
		"A última criança que ajudei a nascer chorou tão baixinho que tive de encostar o ouvido. Ainda escuto aquele choro.",
	},
}

D.genoveva = {
	{
		"Meu tear parou por falta de fio, e o fio parou por falta de lã, e a lã parou porque as ovelhas se foram.",
		"Teci a mortalha de metade da rua. Aprendi a medir o corpo só de olhar quem passa.",
		"Não é macabro. É ofício.",
	},
	{
		"Às vezes teço sem fio, só para sentir o movimento das mãos. Parece oração.",
	},
}

D.hortensia = {
	{
		"A estalagem tem doze camas e nenhum hóspede. Mantenho os lençóis limpos, porque é a única coisa que ainda controlo.",
		"Antes os viajantes chegavam cansados e partiam felizes. Agora ninguém chega. A estrada esqueceu o caminho.",
		"Se precisar de um quarto, não cobro. Só peço que me conte como está o mundo lá fora.",
	},
	{
		"Varro a entrada duas vezes por dia. Cada vez que passo a vassoura, penso que alguém vai surgir na curva.",
	},
}

D.quiteria = {
	{
		"Vendia ervas para tosse, dor e saudade. Agora as ervas secaram, e a saudade é tanta que não cabe em nenhuma receita.",
		"Esta é arruda. Seca como papel. Nos bons tempos curava o susto. Hoje nem o susto reconhece.",
		"Carrego o cesto porque pesa pouco e me faz parecer ocupada. Quem parece ocupada ainda parece viva.",
	},
	{
		"Procurei raízes na mata e só achei terra dura. Até as minhocas foram embora.",
	},
}

D.brigida = {
	{
		"Meu marido era o homem mais forte da rua. Carregava os sacos do moinho sozinho. A fome o deixou leve, e o vento o levou.",
		"Sento aqui porque daqui vejo a porta de casa. Não sei se espero que ele volte ou que eu tenha coragem de entrar.",
		"Não me console, por favor. Já ouvi todas as palavras bonitas, e nenhuma delas é pão.",
	},
	{
		"Dizem que o tempo cura. Aqui ele só passa mais depressa.",
	},
}

D.olinda = {
	{
		"Conto os grãos de arroz que restam. Dezoito. Se eu cozinhar tudo, é uma refeição pequena. Se eu guardar, é uma esperança pequena.",
		"Meu filho pergunta por que a sopa está tão clara. Digo que é para ele ver o fundo da panela e saber que não há o que temer.",
		"Aprendi a mentir com ternura.",
	},
	{
		"Olhe as luzes das casas. Ontem eram vinte e três. Hoje contei dezenove.",
	},
}

D.otavio = {
	{
		"Faço a ronda para impedir saques, mas não há o que saquear. Hoje impedi um menino de roubar um nabo. Dei o nabo a ele e disse que não tinha visto.",
		"O capitão sumiu há duas semanas. Ninguém foi atrás. Ninguém tem forças para ir.",
		"Mantenho a lança porque, sem ela, eu seria só mais um homem com fome.",
	},
	{
		"Os portões continuam fechados à noite. Já não sei se é para proteger a vila ou para impedir que ela fuja.",
	},
}

D.caetano = {
	{
		"Tenho um cajado e nenhum rebanho. As ovelhas morreram primeiro, depois as cabras. Comemos o que sobrou, até ficar só o cajado.",
		"Vago pela vila como quem procura uma ovelha perdida. É o costume. A mão ainda lembra o peso do rebanho.",
		"Ouviu algum balido por aí? Há dias não escuto nenhum.",
	},
	{
		"O último cordeiro nasceu cego. Chorei por ele como se fosse meu filho.",
	},
}

D.nestor = {
	{
		"Fui eu quem ensinou o Abel a tocar o sino. Hoje ele toca o que eu nunca quis ensinar.",
		"Já vi esta vila em festa. Eram tantas luzes que a noite parecia um erro. Agora a escuridão parece a regra.",
		"Guarde o que vir aqui. Alguém precisa lembrar como era antes.",
	},
	{
		"Meus joelhos doem como estas pedras. Quando chover, saberei antes de todos. Mas não vai chover.",
	},
}

D.bento = {
	{
		"Eu carrego água do poço grande para a minha casa. O balde sempre volta com menos do que levei. Deve ter um buraco, ou a água foge sozinha.",
		"Mamãe disse que a água está ficando tímida. Que ela se esconde fundo no chão. Será que dá para chamar?",
	},
	{
		"Se eu fosse água, também ia embora. Aqui ninguém brinca mais.",
	},
}

D.dora = {
	{
		"Estou desenhando a nossa casa quando tinha janela acesa. Fiz o telhado vermelho, mas só tenho carvão.",
		"No desenho, todo mundo sorri e a mesa está cheia. Quando termino, olho a rua e fico confusa.",
		"Você sabe qual é a cor da chuva? Esqueci.",
	},
	{
		"Desenhei a fonte jorrando. Essa eu não precisei inventar.",
	},
}

D.nita = {
	{
		"Estou rezando pela chuva. Já pedi por três dias seguidos. Se eu pedir mais baixinho, talvez Ele escute melhor.",
		"Pedi também pelo meu cachorro, que sumiu. O frade disse que cachorro não precisa de reza. Eu acho que precisa.",
	},
	{
		"À noite eu rezo olhando para a janela. Quando uma luz se apaga, rezo mais um pouquinho.",
	},
}

D.silvestre = {
	{
		"A mata fica longe, e cada viagem me custa um dia de forças. Trago lenha para um fogo pequeno. É a nossa única fogueira.",
		"As árvores também estão secas. O machado entra, e o tronco se parte como osso velho.",
		"Cortei a última árvore do bosque da colina. Sem a sombra, descobri o quanto ela importava.",
	},
	{
		"Queimamos as cadeiras no mês passado. Agora estamos queimando as portas. Não sei o que queimaremos depois.",
	},
}

D.benicio = {
	{
		"Não se aproxime muito. A febre vai de mão em mão. Não é gentileza minha: é medo de passar o que carrego.",
		"Há dois dias não consigo me levantar. Os vizinhos deixam água perto da porta e fogem. Não os culpo.",
		"Se eu morrer, peça ao Heitor uma cova funda. Não gosto da ideia de ser incomodado pelo vento.",
	},
	{
		"O frio me pega até no calor. É estranho tremer num dia que seca até as pedras.",
	},
}

D.jeronimo = {
	{
		"Meu milharal tinha a altura de um homem. Agora tem a altura de um dedo, e nem isso vingou.",
		"Arranquei os talos secos para abrir espaço, como se o espaço fosse o problema.",
		"Plantar sem água é um ato de fé. E a fé também está falhando por aqui.",
	},
	{
		"Pensei em ir embora. Mas para onde vai um lavrador que não leva a terra consigo?",
	},
}

D.firmino = {
	{
		"Divido o serviço com o Heitor. Ele cava de manhã, eu cavo à tarde. Já não há folga, nem para a morte.",
		"A terra aqui está tão dura que preciso de duas pás por cova. Uma quebra na metade.",
		"Se um dia eu parar de cavar, é porque não haverá mais quem enterre.",
	},
	{
		"Tenho vergonha de dizer, mas me acostumei. É o pior de tudo: o hábito.",
	},
}

D.teodoro = {
	{
		"Esta terra era do meu avô, depois do meu pai, depois minha. Agora é só a poeira que me pertence.",
		"Sonhei que chovia. Acordei com o rosto molhado, mas era suor. Fiquei com raiva do sonho.",
		"O poço seco me olha como um olho aberto. Evito passar perto à noite.",
	},
	{
		"Os corvos também desistiram. Nem eles acham o que comer por aqui.",
	},
}

D.isaura = {
	{
		"Lavo com a água do último poço, e ela sai tão suja quanto entrou. Mas é o que há, e a gente vai esfregando.",
		"Lavei a camisa de um menino ontem. Ele não precisará mais dela. A mãe só quis vê-la limpa mais uma vez.",
		"A água não limpa só o pano. Às vezes limpa a vontade de chorar.",
	},
	{
		"Antes cantávamos enquanto lavávamos. Agora esfrego em silêncio, e o rangido do pano é a nossa canção.",
	},
}

D.valeria = {
	{
		"Colhi hoje três batatas do tamanho de ovos de pomba. Pareciam troféus. Cozinhei todas e dividi com a vizinha.",
		"Aprendi que a fartura é um segredo difícil de guardar. A escassez não: todos já sabem.",
		"Esta cesta está quase vazia, mas finjo carregar peso, para que ninguém peça.",
	},
	{
		"Meu pai dizia que a terra devolve o que lhe damos. Dei suor, sementes e lágrimas. Ela devolveu poeira.",
	},
}

D.perpetua = {
	{
		"Rezo pelos que partiram e pelos que ainda vão. A lista é tão longa que já não sei a ordem.",
		"Sou rezadeira há trinta anos. Nunca rezei tanto, nem fui tão pouco ouvida.",
		"Não é fé que me falta. É o tempo entre uma reza e outra.",
	},
	{
		"Uma criança me perguntou o que acontece com quem morre de fome. Respondi que dorme sem barriga. É a melhor mentira que tenho.",
	},
}

D.goncalo = {
	{
		"Levantei metade destas casas. Hoje só remendo as paredes que racham. O barro seca, a pedra se fende, e as casas parecem velhas de repente.",
		"As casas que ficam vazias eu fecho com tábuas. Tenho tábua de sobra.",
		"Não é trabalho que me falta. É razão.",
	},
	{
		"Construir dava orgulho. Fechar portas só dá cansaço.",
	},
}

D.aurelio = {
	{
		"Que a paz nos acompanhe... se ainda souber o caminho. Rezo nesta esquina porque aqui passa mais gente.",
		"Dei a bênção a vinte e dois neste mês. Tantos que já não lembro os rostos, só as mãos frias.",
		"Confessaram-me coisas pequenas: um pão roubado, uma mentira. Absolvi todos. A fome não precisa de penitência.",
	},
	{
		"Meu irmão de ordem, Leonidas, reza junto à fonte. Eu rezo aqui. Cada um segura uma ponta do mesmo fio.",
	},
}

D.raul = {
	{
		"Estou procurando formiga. Se ainda tem formiga, ainda tem coisa viva. Achei uma, mas ela fugiu.",
		"Ontem tinha três. Hoje, só uma. Eu fico aqui para cuidar dela.",
		"Você não vai pisar nela, né?",
	},
	{
		"O pai disse que, quando as formigas sumirem, é hora de ir embora. Eu vou cuidar delas, assim a gente fica.",
	},
}

D.eva = {
	{
		"Esta é a minha filha, a Joaninha. Ela está doente. Não tem remédio, então eu canto.",
		"A mamãe diz que boneca de pano não fica doente. Mas essa fica.",
		"Se ouvir o sino, não conte para ela. Ela tem medo.",
	},
	{
		"Cada vez que o sino toca, eu tapo as orelhas dela.",
	},
}

D.tito = {
	{
		"Estou sentado porque correr cansa. Antes eu corria o dia inteiro. Agora meus pés pesam mais que o corpo.",
		"Minha barriga faz barulho. O pai diz que é o bicho dela pedindo pão. Eu respondo que ele deve esperar, como a gente.",
	},
	{
		"Se você tiver uma história boa, conta. Contar história dá fome, mas passa o tempo.",
	},
}

D.lucinda = {
	{
		"Costuro bainhas em roupas que já não servem a ninguém. Fico com as agulhas porque valem mais que o dinheiro.",
		"A linha vem das mantas velhas. Cada ponto é uma lembrança desfeita.",
		"Remendar é teimosia. Eu sei. Mas a teimosia ainda é o meu ofício.",
	},
	{
		"Fiz um vestido de casamento no ano passado. Não houve casamento. Usaram-no no velório.",
	},
}

D.honorio = {
	{
		"Fico de olho no horizonte para ver se vem chuva, ou ajuda. Ainda não veio nenhuma das duas.",
		"À noite, as luzes das casas vão se apagando, uma a uma. Eu anoto de cabeça. Já sei quais casas estão vazias.",
		"Existe um jeito de saber quem partiu: a chaminé para de fumar.",
	},
	{
		"Há dias vejo um ponto no caminho. Imagino que seja um viajante. Pode ser só uma pedra.",
	},
}

D.madalena = {
	{
		"Meus três filhos dormem juntos para se aquecer. Eu fico acordada, vigiando que respirem.",
		"Cada manhã conto as respirações. Hoje fechei a conta. Amanhã, quem sabe.",
		"Se tiver um pão a mais, pense em mim. Se não tiver, pense em quem tem.",
	},
	{
		"Dei a minha parte ao caçula. Disse que já tinha comido. Ele sabe que não, mas finge. Aprendemos a nos proteger com mentiras.",
	},
}

-- ===================== ELENCO AMPLIADO COM FALA PROPRIA =====================
D.ezequiel = {
	{
		"Acendo um lampião por vez, e ainda assim há mais lampiões apagados que acesos. Subo com a vara, aproximo a mecha e rezo para o óleo aguentar até o fim da rua.",
		"O óleo é contado em colheres. Se encho demais um reservatório, falta ao poste da esquina. Escolho as ruas por onde passa mais gente, e as outras ficam no escuro.",
		"Você repara que algumas luzes tremem? Não é vento. É o óleo pedindo para ir embora. Quando uma apaga de vez, eu a deixo assim, em respeito.",
	},
	{
		"Antes o povo saía à noite só para ver as ruas acesas. Hoje me seguem de longe, porque onde eu passo há luz, e onde há luz ninguém se sente sozinho.",
	},
}

D.amadeu = {
	{
		"Esta máscara não é fantasia. O bico guarda ervas secas: alecrim, arruda, cravo. Dizem que o ar ruim da febre não passa por elas. Eu acredito, porque preciso acreditar.",
		"Examino com o cajado, não com a mão. Os doentes me temem mais do que à doença. Compreendo. Quem vê este rosto sabe que o fim está perto.",
		"Estudei em Salerno, entre livros que prometiam cura para tudo. Aqui descobri que livro nenhum ensina a curar fome. E é a fome que mata; a febre só assina.",
	},
	{
		"Cada visita me custa uma erva a menos no bico. Quando acabarem, usarei um pano molhado em vinagre. A ciência, aqui, se resume ao que ainda sobrou na bolsa.",
	},
}

D.tristao = {
	{
		"Toco o alaúde porque as cordas ainda obedecem, mesmo quando mais nada obedece. Tenho três cantigas alegres e doze tristes. Hoje ninguém pede as alegres.",
		"Cantei numa taverna de feira, no tempo em que havia feira. Pagavam-me em vinho e aplauso. Agora pagam em silêncio, que é a moeda mais honesta.",
		"Componho uma balada sobre esta vila. Tem um verso sobre a fonte, outro sobre os lampiões, e ainda procuro o final. Todo final que escrevo parece cedo demais.",
	},
	{
		"Se quiser ouvir algo, fique um instante. Não vou cobrar. Ninguém aqui tem com que pagar, e eu já esqueci o valor das moedas.",
		"Mas peço uma coisa: não bata palmas. O som das mãos me lembra pás sobre a terra.",
	},
}

D.benvindo = {
	{
		"Sou padeiro de ofício e teimoso de natureza. Amasso a farinha de casca com o que resta de trigo e faço três pães por dia. Cada um é dividido em oito fatias, e nenhuma sobra.",
		"Meu avô dizia que o cheiro de pão chama os vivos e acorda os mortos. Hoje o forno cheira a casca queimada. Mesmo assim, as crianças vêm em fila, só para respirar.",
		"Quando o trigo acabar, farei pão de lembrança. Amassarei água e saudade, assarei até dourar, e todos fingiremos mastigar. Já vi gente se alimentar de menos.",
	},
	{
		"A fila diminui a cada semana. Não por falta de fome. Por falta de gente.",
	},
}

D.gedeao = {
	{
		"Servi em duas campanhas e voltei inteiro. Agora estou aqui, vigiando um muro que nenhum inimigo quer atacar. A fome é um exército que já passou por todos os portões.",
		"O escudo é pesado e a barriga é leve. Tem dias em que me pergunto qual dos dois me derruba primeiro.",
		"O capitão partiu há um mês, dizendo que ia buscar reforços. Mantenho o posto como prometi. Quem faz promessa de guarda, guarda até o fim, mesmo sem saber qual é o fim.",
	},
	{
		"Se vir movimento na estrada, me avise. Eu gostaria de ter, ao menos, uma ameaça para enfrentar.",
	},
}

D.ildefonso = {
	{
		"Fico com a tocha porque os lampiões já não bastam. Onde a minha luz alcança, ninguém tropeça. Onde não alcança, ninguém reclama.",
		"A tocha consome resina, e resina já é raridade. Acendo-a no fim da tarde e a apago antes da madrugada, para sobrar um toco para o dia seguinte.",
		"À noite escuto coisas que o dia não deixa ouvir. Choro baixo atrás das paredes. Reza. Um copo vazio rolando no chão. Não anoto nada. Mas ouço tudo.",
	},
	{
		"A chama é pequena, mas é minha. Converso com ela quando ninguém conversa comigo.",
	},
}

D.hermano = {
	{
		"Caço o que resta, e resta pouco. Ontem segui o rastro de uma lebre por meio dia e achei só a toca vazia. Os bichos também deixaram esta terra.",
		"Quando a vila ainda tinha mata por perto, eu voltava com perdiz, javali, às vezes um veado. Agora a mata virou lenha, e a lenha virou cinza.",
		"Guardo três flechas boas. As outras dei ao coveiro, que as usou de estaca. Não pergunte para quê. Há usos de flecha que um caçador não conta.",
	},
	{
		"Se achar uma pena de ave no caminho, guarde. É a prova de que algo ainda voa por aqui.",
	},
}

D.cipriano = {
	{
		"Vim de longe, de um caminho que dura quarenta dias. Parei aqui porque vi luz. Quem anda à noite aprende a confiar em qualquer brasa que o chame.",
		"Peregrino é quem caminha sem ser dono do chão. Pensei que aqui encontraria pousada, mas a estalagem está vazia e as camas, desfeitas. Durmo onde a calçada ainda guarda calor.",
		"Passei por três vilas antes desta. Nas três a história era a mesma: poço seco, campo rachado, gente calada. Começo a achar que não estou viajando. Estou seguindo a mesma sombra.",
	},
	{
		"Levo uma concha no chapéu, prova de que cheguei ao santuário. Mas volto de mãos vazias, porque o que busco não se compra nem se encontra: só se atravessa.",
	},
}

D.eliseu = {
	{
		"Faço caixões, mais do que portas. A tábua boa acabou há semanas. Uso o que sobra: mesas, bancos, prateleiras. Cada móvel desta vila vai virar caixão.",
		"Meço o corpo com os olhos antes de ver o defunto. O ofício me ensinou a conhecer a vida pelo tamanho que ela deixa.",
		"Meu martelo ainda canta, mas agora só toca uma música. Pregos escassos, madeira escassa, tempo escasso. Só a tristeza é farta.",
	},
	{
		"Se me vir cortando uma tábua inteira, é porque achei uma boa. Será para um berço. Ainda faço um por mês, e é o que me mantém.",
	},
}

D.macario = {
	{
		"Não, eu não estou bêbado. Estou só... equilibrado de outro jeito. A garrafa tem o resto de uma cerveja que fiz quando ainda havia cevada. Gole a gole, eu me despeço dela.",
		"O vinho acabou primeiro, depois a aguardente, depois o vinagre. Já bebi a lembrança do vinho, e ela é pior que a ressaca.",
		"Quando bebo, esqueço que a vila agoniza. O problema é que, quando acordo, ela continua agonizando, e eu continuo aqui para ver.",
	},
	{
		"Você tem uma gota? Uma só, de qualquer coisa. Água serve. A memória do sabor é que importa.",
	},
}

D.teofilo = {
	{
		"Copio o Livro das Horas à luz de uma vela só. A tinta é feita de fuligem e vinagre, e a letra sai trêmula, mas copio mesmo assim. O que é escrito sobrevive ao escriba.",
		"O mosteiro mandou tantos volumes para serem guardados aqui, e aqui os guardo, atrás da porta. Se a vila cair, que ao menos reste um livro que diga como ela era.",
		"No fim da página deixo sempre um espaço em branco. Se um dia vier alguém aprender a ler aqui, que tenha onde escrever o próprio nome.",
	},
	{
		"A vela está no fim. Se você tiver um toco, troco por uma página bonita, com iluminura. Mesmo sem saber ler, vai gostar dos desenhos.",
	},
}

D.romulo = {
	{
		"O barro desta terra rachou como a pele do lavrador. Preciso buscá-lo no fundo do rio seco, onde ainda guarda um pouco de umidade. Cada pote que faço é um pedaço de rio.",
		"Faço jarros que ninguém enche e potes que ninguém usa. Vendo-os para guardar sementes que nunca serão plantadas. Mas o pote é bonito, e isso basta por hoje.",
		"O forno só acende uma vez por semana. Tenho de escolher: um pote perfeito ou quatro razoáveis. Aprendi a gostar dos defeitos. Os defeitos provam que fui eu.",
	},
	{
		"Se o pote rachar no forno, eu o quebro e uso o caco para riscar o chão. Nada se perde, nem a ruína.",
	},
}

D.lourival = {
	{
		"Sou o segundo escrivão. O primeiro adoeceu. O terceiro ainda não existe, e a conta é simples: estamos eu e o livro, e o livro cresce mais depressa do que eu.",
		"Hoje escrevi onze nomes. Alguns eu conhecia pelo rosto, outros só pelo nome. Pergunto se isso torna a escrita mais fácil, e a resposta é sempre não.",
		"Há dias em que escrevo tão devagar que a tinta seca na ponta da pena. É a minha forma de adiar o próximo nome.",
	},
	{
		"O papel acabou. Escrevo agora na face interna de cascas de árvore. Não vai durar. Mas o que durou, afinal?",
	},
}

D.isidoro = {
	{
		"Ajudo o Abel com o sino maior. Ele puxa e eu seguro a corda, para que o badalo não bata demais. Há dias em que o som é tão pesado que a torre treme.",
		"Dizem que o sino tem a voz da vila. Se é assim, a nossa voz está rouca. Já não grita, não canta. Apenas avisa.",
		"Quando eu era menino, tocava-se o sino para a festa da colheita, e a vila inteira corria à praça. Hoje, se tocar duas vezes seguidas, ninguém corre. Todos esperam o terceiro toque.",
	},
	{
		"Subo as escadas devagar. A cada degrau penso em quem foi o último a subir por elas.",
	},
}

D.abraao = {
	{
		"Arei o campo de novo, mesmo sem semente. Alguém precisa manter a terra desperta. Se ela dormir demais, esquece como se produz.",
		"Meu vizinho plantou pedras, só para ter o que enterrar. Eu ri, depois chorei. Não por ele. Por entender.",
		"Ainda guardo um punhado de trigo na cinta. Não é para comer. É a última semente da minha linhagem. Se a chuva voltar, planto. Se não voltar, será enterrada comigo.",
	},
	{
		"A enxada tem o cabo gasto no formato da minha mão. Se um dia eu partir, quem a pegar vai sentir o meu aperto.",
	},
}

D.dimas = {
	{
		"Derrubei o último carvalho do vale ontem. Era tão velho que tinha nome. Chamavam-no de Pai. Deu lenha para duas semanas, e agora o vale está pelado.",
		"O machado cega depressa, porque a madeira seca é dura como osso. Afio-o à noite, pelo som da lima, sem luz.",
		"Cortamos tudo para queimar, e queimamos tudo para suportar o frio. É um círculo que não leva a lugar nenhum. Mas ninguém tem outro.",
	},
	{
		"Já ouvi dizer que é possível plantar uma árvore. Não sei como se faz. Sempre soube apenas derrubar.",
	},
}

D.icaro = {
	{
		"Sargento Ícaro, ao seu dispor. Dos dezoito homens da guarda, restam cinco. Os outros foram embora de noite, sem avisar. Não os culpo: homem faminto não defende nada.",
		"Faço a ronda duas vezes por dia, mesmo sem ordem. Quando a ronda termina, começa de novo. É o que me mantém sargento.",
		"Dizem que a vila vai ser abandonada. Eu respondo que não. Alguém precisa ficar para fechar o portão. Esse alguém serei eu.",
	},
	{
		"Disciplina é a última riqueza que ainda temos. Não a gastem à toa.",
	},
}

D.crispim = {
	{
		"Tenho oitenta e dois anos, ou setenta e nove. Perdi a conta depois do terceiro filho. Vi três pestes, duas fomes e um incêndio. Esta vila é a que mais demora a morrer.",
		"Minha neta me traz um gole de caldo todo dia. Nunca pergunto de onde vem. Se perguntar, terei de recusar.",
		"Quando eu era novo, a gente dançava na praça nas noites de lua cheia. Hoje a lua é a mesma, só que ninguém mais levanta o rosto para vê-la.",
	},
	{
		"Sentar aqui, perto da luz, é o que me resta. A luz ajuda a lembrar.",
	},
}

D.ptolomeu = {
	{
		"Sou vigia da torre norte. Subo todo fim de tarde e olho a estrada. Nunca vi ninguém chegar. Vi muitos partirem.",
		"À noite, do alto, as casas parecem estrelas apagadas. As que ainda estão acesas são a única constelação de que me lembro.",
		"Se uma luz apaga, desço e bato na porta. Na maioria das vezes ninguém responde. Mas bato mesmo assim. É o mínimo de respeito que se deve aos vivos... e aos outros.",
	},
	{
		"Não durmo mais do que quatro horas. Os sonhos aqui são pesados demais para carregar.",
	},
}

D.wenceslau = {
	{
		"Reconstruo o muro que cai. Cada pedra que recoloco é uma pedra a menos no chão e uma a mais entre nós e o escuro.",
		"A argamassa é feita de barro e esperança. Mais barro que esperança, devo dizer. Mas o muro aguenta, por enquanto.",
		"Meu pai construiu a fonte. Meu avô, o poço. Eu só remendo. Mas remendar também é construir, de um jeito menor.",
	},
	{
		"Se uma pedra me cair no pé, será menos pior do que a que me cai no peito toda manhã.",
	},
}

D.feliciano = {
	{
		"A febre sobe de noite e desce de manhã. Neste vai-e-vem, aprendo quando é dia pelo suor, não pela luz.",
		"Pedi à parteira uma erva. Ela disse que as ervas acabaram. Pedi ao frade uma prece. Ele disse que as preces também. Estou numa lista de coisas que faltam.",
		"Não tenho medo de morrer. Tenho medo de morrer sozinho. Por isso fico aqui, perto da luz, onde alguém passa.",
	},
	{
		"Se eu tossir, não se assuste. É o jeito que meu corpo encontrou de dizer que ainda está aqui.",
	},
}

D.jacinto = {
	{
		"Estendi a tigela em outras vilas. Em todas, a mesma resposta: um olhar de quem também queria uma tigela. Aprendi que a esmola é um espelho.",
		"Aqui recebo mais histórias do que moedas. Aceito as histórias, que são mais leves e ocupam menos espaço na tigela.",
		"Já fui soldado do rei e, antes disso, aprendiz de sapateiro. Não sou nada disso agora. Sou apenas alguém que ainda se levanta pela manhã.",
	},
	{
		"Meu truque é sorrir sem mostrar os dentes. Assim ninguém vê o que falta.",
	},
}

D.joel = {
	{
		"Meu rebanho eram quarenta cabeças. Perdi todas para a sede. A última, Esperança, morreu ontem de manhã. Enterrei-a com o sino que ela usava.",
		"Ainda ando pelo pasto, de hábito, com o cajado e o cantil. O pasto sente falta dos passos. Eu sinto falta do peso dos olhos delas em mim.",
		"Ovelha não reclama de fome, só olha. Aprendi a ler esse olhar melhor do que qualquer livro. Hoje o leio nas pessoas.",
	},
	{
		"Acordo cedo e olho o pasto. Às vezes juro ouvir um sino. É só o vento nas pedras.",
	},
}

D.ermelinda = {
	{
		"Vendo velas de sebo, as últimas. Uma vela dura uma noite, e uma noite basta para quem tem medo do escuro. Cobro um pedaço de pão, quando há.",
		"Faço as velas derretendo os tocos que me trazem. Nunca sai uma vela inteira: sai uma vela feita de outras velas. Acho bonito. É como a vila, feita de pedaços.",
		"Quem acende uma vela quase sempre fecha os olhos. Diz que é para rezar. Eu acho que é para ver melhor o que o escuro esconde.",
	},
	{
		"A luz que esta bandeja vende é pouca, mas cabe na palma da mão. Leve uma, se tiver como pagar. Se não tiver, olhe a chama um instante: de graça.",
	},
}

D.joaquina = {
	{
		"Eu e meu marido assávamos pão de madrugada. Ele foi buscar farinha e não voltou. Continuo acendendo o forno todo dia, para o caso de o cheiro guiá-lo de volta.",
		"A farinha de casca rende pouco e tem gosto de terra. Mas, quentinha, quase ilude. Dizem que a ilusão alimenta. Mentem, mas ajuda.",
		"As crianças esperam na porta do forno antes do sol. Dou a elas as pontas, que são as partes mais gostosas. Eu fico com o miolo, que é o mais frio.",
	},
	{
		"Se vier um dia de fartura, farei um pão tão grande que vão precisar de dois para carregar. Até lá, faço o que cabe nas mãos.",
	},
}

D.salome = {
	{
		"Colho o que ainda nasce: ortiga, dente-de-leão, uma menta que teima. Cozinho tudo junto e chamo de remédio. Não cura nada, mas cada um sente que está se tratando.",
		"As ervas boas morreram primeiro. Ficaram as daninhas, que já nascem esquecidas. Aprendi a conversar com elas. São as únicas que respondem.",
		"A casca de salgueiro baixa a febre. Mas as árvores estão sendo cortadas para lenha. Cada vez que um salgueiro cai, perco um remédio e ganho um doente.",
	},
	{
		"Leve um ramo de alecrim. Cheira bem e não sustenta, mas lembra a casa de quando se tinha jardim.",
	},
}

D.aldina = {
	{
		"Ando com esta lanterna para que ninguém caminhe sozinho no escuro. Se vir alguém perdido, eu o guio até a casa. Só isso. Já é muito.",
		"A chama dentro do vidro gasta o óleo devagar. Mantenho-a baixa, só para clarear os passos. Quem vive no escuro aprende a se contentar com pouco.",
		"Minha filha tinha medo do breu. Eu lhe emprestava a lanterna para dormir. Agora, mesmo sem ela, carrego a lanterna comigo. Por hábito. Por saudade.",
	},
	{
		"Se precisar atravessar a vila de noite, chame. Eu vou na frente.",
	},
}

D.serafina = {
	{
		"Canto de manhã e ao entardecer. Nada elaborado: uma melodia sem palavras, que sobe e desce como a respiração. Dizem que acalma os doentes. Pode ser só hábito, mas eles dormem.",
		"Aprendi a cantar com minha avó, diante de um poço cheio de água. Hoje canto diante de um poço cheio de silêncio. O eco é o mesmo.",
		"Há notas que só saem quando o coração está vazio. Cantei a mais alta ontem, para ver se o céu respondia. Respondeu com uma nuvem. Uma só. Mas foi bonita.",
	},
	{
		"Se vier ouvir, fique em silêncio. A canção é frágil. Qualquer palavra a quebra.",
	},
}

D.herminia = {
	{
		"Meu marido ia ao campo todas as manhãs. Voltou numa carroça, coberto por um pano. Desde então deixo o prato dele posto. Não é loucura. É respeito.",
		"O luto aqui virou uniforme. Quase todas as mulheres o vestem. Eu o visto há tanto tempo que a cor da minha roupa já é a do meu rosto.",
		"Rezo para que ele me espere. Não tenho pressa de ir, mas não tenho pressa de ficar. Estou no meio, o lugar mais difícil.",
	},
	{
		"Obrigada por parar para me ouvir. Faz tempo que ninguém para.",
	},
}

D.leocadia = {
	{
		"Crio quatro filhos com a comida de dois. Eles não reclamam, e isso me assusta mais do que se gritassem.",
		"Minha filha mais velha ensina os pequenos a ficarem quietos. Diz que assim gastam menos. Quando ouço, quero chorar, mas guardo as lágrimas também. Água não se desperdiça.",
		"Se a chuva chegar, levo as crianças para a praça, para sentirem. Elas nunca viram. Vão pensar que o céu está desabando.",
	},
	{
		"Não me venha com pena. Venha com um pedaço de pão, ou com um pouco de esperança. Qualquer um dos dois serve.",
	},
}

D.clementina = {
	{
		"A água do rio secou, mas ainda lavo. Uso a da cisterna, que é turva e pouca. A roupa sai mais cinza do que entra, e ninguém reclama.",
		"Esfrego devagar para não gastar o pano. Os trapos são tudo o que as famílias têm. Se um se desfaz, o inverno vence.",
		"Lavei hoje uma camisa de criança. Pequenina. Era de um dos filhos da Madalena? Não perguntei. Torci devagar e deixei pendurada ao sol, como se alguém fosse buscá-la.",
	},
	{
		"Água suja ainda é água. Ensinaram-me a respeitá-la até o último respingo.",
	},
}

D.benigna = {
	{
		"Tenho uma única agulha e um novelo de cinco cores. Conserto tudo com cinco cores, e as roupas da vila parecem um arco-íris triste.",
		"Uso retalhos de roupas de quem partiu. Costuro-os em coletes, mantas, cobertores. Assim os mortos aquecem os vivos.",
		"Quando o fio acabar, desfaço as minhas mangas. Depois as da minha filha. Depois, as lembranças. Sempre há algo a desfiar.",
	},
	{
		"A linha treme na minha mão. Mas o ponto sai firme. O corpo esquece, mas o ofício lembra.",
	},
}

D.nazare = {
	{
		"Rezo pelos que não têm quem reze. São muitos, e o dia é curto. Divido as preces em turnos, como quem divide o pão.",
		"Aprendi que Deus não responde a quem pede, mas a quem insiste. Por isso insisto. Já faz três meses.",
		"Quando rezo, imagino uma chuva fina. Primeiro uma gota, depois outra, depois uma cortina. Termino a oração molhada de lembrança.",
	},
	{
		"Se quiser rezar comigo, não precisa saber as palavras. Basta fechar os olhos e desejar com firmeza.",
	},
}

D.mirela = {
	{
		"Eu seguro uma vela porque mamãe disse que, se eu cuidar dela, ela cuida de mim. A chama é pequena, mas eu acho que ela escuta.",
		"Quando o vento sopra, eu escondo a chama na mão. Dói um pouquinho, mas vale a pena. Uma vela apagada é muito triste.",
		"Vou acender a vela da minha casa quando chegar. Assim, quem chegar depois vai achar o caminho.",
	},
	{
		"Quer ver como ela dança? Olhe de perto. Ela só dança para quem fica quieto.",
	},
}

D.toninho = {
	{
		"Esta lanterna é do meu pai. Ele deixou eu segurar, porque eu disse que não tenho medo do escuro. Ele sabe que é mentira, mas deixou.",
		"Eu ando de lanterna para ver as coisas que o dia esconde. Ontem vi uma aranha fazendo teia na fonte. Disse oi. Ela não respondeu.",
		"Quando a luz balança, as sombras dançam. Eu dou nome a elas. Aquela comprida é o Velho Tobias. A pequena é o meu cachorro que foi embora.",
	},
	{
		"Se você vier comigo, divido a luz. Só não mexa, senão acaba mais cedo.",
	},
}

D.biel = {
	{
		"Isto é um pão! Um pão de verdade, pequeno, mas de verdade. A padeira me deu porque eu varri a porta. Vou guardar até a noite.",
		"Estou com tanta fome que cheirei o pão uns dez minutos. Depois pensei: se eu comer, acaba; se eu cheirar, dura. Escolhi cheirar.",
		"Quando eu crescer, vou ser padeiro. Vou fazer pães enormes, do tamanho da porta, e distribuir para todo mundo. Sem fila.",
	},
	{
		"Um pedacinho para você? Não! Era brincadeira. Tá bom, só a casquinha. Mas não conta para a minha irmã.",
	},
}

D.aninha = {
	{
		"Estou aprendendo a ler. Frei Teófilo me ensina as letras. Já sei o A, o B e o O. Com o O consigo escrever 'olho', porque faltam o L e o H, mas eu imagino.",
		"O livro é maior do que eu. Para virar a página, preciso abraçá-lo. Frei Teófilo diz que isso se chama respeito.",
		"Quando eu souber ler tudo, vou ler em voz alta para quem não sabe. Assim todo mundo viaja sem sair da praça.",
	},
	{
		"Sabe qual letra eu mais gosto? A que parece uma porta aberta: o A. Quando escrevo, sinto que alguém vai entrar.",
	},
}

D.chiquinho = {
	{
		"Desenho no chão com um graveto. Hoje desenhei uma casa com a chaminé fumegando. Depois chegou a poeira e apagou tudo.",
		"Eu desenho coisas boas porque o chão aguenta qualquer coisa. Já desenhei um rio inteiro. Ele secou antes do almoço.",
		"Se eu desenhar um pão bem grande, será que alguém come? Já tentei. Só a formiga veio. Mas ela gostou.",
	},
	{
		"Pode pisar no desenho, se quiser. Eu desenho de novo.",
	},
}

D.maricota = {
	{
		"Esta é a Sinhá. Ela não tem olhos, mas vê tudo. Quando eu choro, ela sabe. Quando eu rio, ela finge que é com ela.",
		"Eu a levo para a cama e conto histórias. Ela nunca dorme antes de mim. É uma boa guardiã.",
		"Fiz um vestido novo para ela com um retalho que a costureira me deu. Ficou grande. Mas ela diz que prefere assim. Tem mais espaço para sonhar.",
	},
	{
		"Se você quiser, pode brincar com ela. Mas só um pouquinho. Ela é tímida.",
	},
}

-- ===================== DIALOGOS GENERICOS POR PAPEL =====================
-- usados pelos NPCs sem fala propria (Papel = chave abaixo); duas conversas curtas cada
D.papel = {
	lavrador = {
		{ "A terra rachou tanto que dá para enfiar a mão. Semeio mesmo assim, para ter o que fazer com as mãos.", "Dizem que a chuva volta no outono. Eu digo que o outono também está atrasado." },
		{ "Meu campo era verde até o ano passado. Agora é cor de osso." },
		{ "Enterrei metade da semente e a outra metade escondi. Se a chuva voltar, saberei qual ficou viva.", "Aprendi a conhecer o clima pelo peso do ar. Hoje pesa como um pano molhado e seco." },
		{ "A enxada me conhece melhor do que o meu filho. Ainda me atende." },
	},
	lenhador = {
		{ "A lenha está cada vez mais longe. Hoje caminhei o dobro para trazer metade do feixe.", "Queimamos tudo que é madeira. Ainda assim, passamos frio." },
		{ "O machado ficou mais pesado que a minha coragem." },
		{ "Cada árvore que derrubo me olha antes de cair. Já aprendi a não olhar de volta.", "A lenha verde fumaça e a seca queima rápido. No fim, tudo vira calor emprestado." },
		{ "Se faltar lenha, queimaremos as portas. Depois as janelas. Depois, as casas. É a ordem dos pobres." },
	},
	pastor = {
		{ "Procuro um rebanho que já não existe. Faço o caminho do mesmo jeito, por hábito.", "O cajado me segura de pé. É mais útil agora do que era no pasto." },
		{ "Ainda ouço sinos de ovelha à noite. Devem ser lembranças com sino." },
		{ "Ontem contei as ovelhas de cabeça e deu o número de sempre. Fui ver, e era só o costume.", "O silêncio do pasto é diferente do silêncio da praça. O do pasto espera. O da praça aceita." },
		{ "Pastor que perde o rebanho vira só um homem com um pau." },
	},
	guarda = {
		{ "Alto! ... Ah, é só mais um que passa. Siga, não há o que guardar.", "Antes impedíamos ladrões. Agora impedimos que alguém caia." },
		{ "A lança me ajuda a ficar em pé. É o que sobrou do ofício." },
		{ "Fico aqui desde o amanhecer. Já vi passarem três carroças e nenhum vivo.", "A ordem era guardar a vila. Não disseram do quê." },
		{ "Se alguém entrar à noite, grito. Se ninguém entrar, também. A voz precisa de exercício." },
	},
	mendigo = {
		{ "Uma moedinha? Aceito também uma migalha, um gole ou uma palavra gentil.", "Todos aqui estão no mesmo buraco. Só que eu cheguei primeiro e já me acostumei ao fundo." },
		{ "Quando a vila se encher outra vez, lembre-se de que eu estive aqui." },
		{ "Dou bom-dia a todos. Alguns respondem. Os que não respondem eu perdoo, que a fome tira a boca do assunto.", "Há quem me dê uma casca de pão e peça silêncio em troca. Eu aceito. O silêncio é barato." },
		{ "Hoje uma criança me chamou de tio. Foi o dia mais bonito da semana." },
	},
	coveiro = {
		{ "Cavo desde o amanhecer. A terra rende pouco, mas é o único serviço que nunca para.", "Há dias em que enterro três. Em outros, enterro um e vejo mais dois a caminho." },
		{ "Aprendi o nome de cada cruz. Agora são tantas que me falta cabeça." },
		{ "A terra desta vila é dura em cima e mole embaixo. Parece gente: guarda a maciez onde ninguém vê.", "Faço a cova pelo tamanho do medo, não do morto. Quanto maior o medo, mais fundo eu cavo." },
		{ "No dia em que eu não tiver o que fazer, serei o primeiro a me preocupar." },
	},
	doente = {
		{ "Fique longe, por favor. Não sei se é febre ou fraqueza, mas ninguém quer descobrir.", "Tenho sede, mas a água está turva. Tenho fome, mas o pão sumiu. Só a tosse me sobrou." },
		{ "Se eu dormir, me acorde. Se eu não acordar, avise o coveiro." },
		{ "A cada manhã conto os dedos para ver se ainda são dez. Sou meio supersticioso e meio desesperado.", "Quando tusso, a vizinha fecha a janela. Não a culpo. Eu também fecharia." },
		{ "Se for me visitar, leve um pouco de silêncio. Eu o aproveito melhor que o remédio." },
	},
	monge = {
		{ "Que a paz esteja convosco. Rezo pelos que se foram e pelos que ainda vão.", "Esta vila precisa de mais braços e de menos covas. Mas só tenho palavras." },
		{ "Quando a fé fraqueja, rezo mais alto. É um truque antigo, e às vezes funciona." },
		{ "O jejum que eu fazia por escolha agora é de todos. Acho que Deus me tomou a palavra.", "Os salmos que cantava na capela agora são canto de despedida. Não mudei a letra. Mudou a plateia." },
		{ "Dizem que a fé move montanhas. Aqui bastaria que movesse uma nuvem." },
	},
	sineiro = {
		{ "O sino é o último relógio da vila. Marca só a hora de morrer.", "Toco devagar. O povo já tem pressa demais de ir embora." },
		{ "O badalo está rachado. Prefiro assim: o som fica mais triste, mais honesto." },
		{ "O sino já pesa mais que o braço que o toca. Tocamos juntos, o sino e eu, numa troca de cansaço.", "Cada toque abre uma conta no ar. Quem ouve sabe contar sozinho." },
		{ "O vento leva o som para longe. Espero que chegue a quem precisa ouvir." },
	},
	ferreiro = {
		{ "A forja está apagada e o ferro enferruja. Faço o que dá: afio pás e conserto cruzes.", "Antes eu martelava até tarde. Agora o silêncio pesa mais que o martelo." },
		{ "Deixo a bigorna limpa. Se a lenha voltar, estarei pronto." },
		{ "Meu fole está furado e a brasa, no fim. Mesmo assim afio uma ponta aqui, outra ali. A mão precisa lembrar.", "O ferro conta histórias a quem sabe ouvir: este aqui já foi arado, depois espada, depois arado de novo." },
		{ "Se trouxer lenha, faço o que pedir. Se não trouxer, faço só pregos." },
	},
	escrivao = {
		{ "Anoto os nomes dos que partem. O livro está cheio de tinta, e a vila, de espaços vazios.", "Escrevo devagar para que a tinta dure. Já racionamos até as palavras." },
		{ "A última frase de cada página é sempre a mesma: 'sem herdeiros'." },
		{ "Escrevo o que acontece e o que deveria ter acontecido, em colunas separadas. A segunda coluna é maior.", "O senhor destas terras exige relatórios. Eu os envio, e ninguém lê. Mas escrever ainda me organiza." },
		{ "Letra torta é sinal de dia ruim. Hoje a letra está torta." },
	},
	vigia = {
		{ "Olho a estrada desde o amanhecer. Nada vem. É o trabalho mais fácil e mais cansativo que já tive.", "À noite, as luzes das casas diminuem. Eu as conto como quem conta moedas." },
		{ "Se algo aparecer, grito. Se nada aparecer, também grito, só para sentir que ainda tenho voz." },
		{ "Quando a vila dorme, escuto o respirar das casas. Algumas respiram mal.", "Não vi ninguém passar pela estrada desde a lua nova. Anoto assim mesmo: 'nada novo'." },
		{ "Ficar acordado é um serviço. Dormir, um luxo." },
	},
	pedreiro = {
		{ "Remendo muros que racham. A terra seca puxa as pedras, e as casas parecem cansar.", "Qualquer pedra solta pode ser a última. Aprendi a pisar com cuidado." },
		{ "Construir era ofício. Remendar é teimosia." },
		{ "A pedra não adoece, não envelhece, não pede pão. Invejo-a um pouco.", "Cada casa que remendo é uma promessa de que alguém ainda vai morar nela." },
		{ "Se o muro cair, eu o levanto. Se eu cair, que alguém me levante também." },
	},
	feirante = {
		{ "Barraca aberta, banca vazia. Fico aqui porque o costume pesa mais que a razão.", "Ninguém compra, ninguém vende. Mas todos passam e olham, como quem visita um túmulo." },
		{ "Ontem vendi uma casca de pão por duas moedas. O comprador agradeceu e chorou." },
		{ "Arrumo a banca todo dia, na mesma ordem, mesmo vazia. A ordem é o último estoque que me resta.", "Ontem apareceu um freguês e eu não tinha o que vender. Dei a ele o meu bom-dia. Pareceu aceitar." },
		{ "Na feira antiga havia gritos, risos, cheiros. Hoje há eco." },
	},
	velho = {
		{ "Já vi muitos anos ruins. Nenhum se compara a este.", "Meus filhos foram para a cidade. Fiquei, porque o sono é mais leve na própria cama." },
		{ "Quando eu morrer, não gastem tábua comigo. Há crianças que precisam mais." },
		{ "Aprendi com o tempo que o passado engana: sempre parece mais cheio do que foi.", "Já fui rápido como um cervo. Hoje sou rápido como uma nuvem em dia sem vento." },
		{ "Quem vive muito acaba conhecendo todos os mortos de uma vila. Eu conheço quase todos." },
	},
	lavadeira = {
		{ "Lavo o que posso, mas a água está tão suja que a roupa sai pior.", "Quase tudo que lavo é roupa de quem partiu." },
		{ "A água, mesmo escura, ainda é um jeito de ocupar as mãos." },
		{ "Esfrego a roupa até clarear e ela volta a sujar de tristeza. Não é a terra que suja. É o tempo.", "A água que escorre da bacia tem cor de chuva que não veio." },
		{ "Lavar é o único gesto que ainda tem fim: a peça sai limpa." },
	},
	costureira = {
		{ "Remendo o que resta. A linha é pouca, mas a teimosia é muita.", "Quando a roupa não serve mais a ninguém, desfio para fazer outra." },
		{ "Cada ponto é uma pequena promessa. Algumas ainda cumpro." },
		{ "Costuro botões em roupas que ninguém mais abotoa direito. O gesto me acalma.", "Cada remendo é um ponto de vista: o de quem quer ficar." },
		{ "A agulha pesa mais agora. Não é o ferro. É o que ela costura." },
	},
	viuva = {
		{ "Meu marido saiu para procurar água e não voltou. Espero até hoje, sentada.", "Não me diga que o tempo cura. Aqui ele só passa depressa." },
		{ "Tenho a casa, as paredes e o silêncio. Só me falta quem os preencha." },
		{ "Falo com o meu marido todas as noites. Ele não responde, mas eu já sei as respostas.", "O luto não é uma roupa. É um lugar onde se mora." },
		{ "As lágrimas já acabaram. Ficou só o gesto." },
	},
	mae = {
		{ "Meu filho não chora mais. Prefiro que chore. Choro é sinal de força.", "Divido o pouco que tenho em porções cada vez menores. Já não sobra nem para o sonho." },
		{ "Olho as luzes das casas. Algumas já não acendem. Rezo para que a minha não seja a próxima." },
		{ "Faço o prato render com água e imaginação. As crianças já descobriram, mas fingem não saber.", "Todo dia pergunto a elas o que sonharam. Quase sempre é comida." },
		{ "Nunca fui tão forte. Também nunca tive tanto medo de ser forte." },
	},
	varredora = {
		{ "Varro a poeira que o vento traz de volta. É um ofício sem fim, mas me ocupa o dia.", "A poeira é a única coisa que cresce por aqui." },
		{ "Se eu parar de varrer, a vila fica com cara de abandono. E ainda não é isso." },
		{ "Varro a poeira de um lado para o outro. Ela não vai embora, mas a vassoura acha que sim.", "Antes eu varria folhas. Agora varro a própria terra, que se soltou." },
		{ "Se o chão está limpo, a vila parece viva. É uma mentira útil." },
	},
	parteira = {
		{ "Faz meses que não nasce criança. As mães não aguentam, ou não têm leite.", "Ainda levo meus panos limpos, esperando que alguém precise." },
		{ "O último choro de recém-nascido que ouvi foi tão fraco que parecia suspiro." },
		{ "Há meses não faço um parto. As mulheres evitam. Sabem que a casa que nasce não tem o que dar.", "Guardo meus panos limpos para o dia em que a vida voltar. Lavo-os todo mês." },
		{ "Quando uma criança nasce, ainda choro de alegria. Mas ninguém mais me chama." },
	},
	rezadeira = {
		{ "Rezo por todos, mas Deus parece demorar a responder. Talvez esteja ocupado.", "Não perco a fé. Perco só a pressa por uma resposta." },
		{ "Nas últimas semanas só me pedem uma coisa: que a próxima noite não seja a última." },
		{ "Rezo para santos de que já não sei o nome. Os mais antigos escutam melhor.", "Dizem que prece sem resposta é prece guardada. Tenho muitas guardadas." },
		{ "O rosário se desgasta por onde passo os dedos. Em breve estará liso." },
	},
	camponesa = {
		{ "Colhi batatas do tamanho de ovos de pomba. Pareciam troféus.", "Divido o pouco com a vizinha. Se eu fosse boa de conta, não dividiria. Mas sou boa de coração." },
		{ "Os campos já não dão nem o susto de uma colheita." },
		{ "Troquei uma galinha por uma pedra de sal. Foi um bom negócio, dizem.", "A horta virou pó. Ainda ponho água nela, de hábito, e a terra aceita como se fosse beber." },
		{ "O que a gente planta, a terra devolve. Hoje devolveu só o susto." },
	},
	menino = {
		{ "Você tem pão? Não precisa ser inteiro. Pode ser um pedaço, uma migalha, qualquer coisa.", "Antes eu brincava de pega-pega. Agora brinco de ficar parado, para gastar menos." },
		{ "Meu amigo foi embora com os pais. Disse que escreve, mas eu não sei ler." },
		{ "Aposto corrida com a minha sombra. Ela sempre ganha, porque no escuro ela some e eu fico.", "Peguei uma pedra e disse que era ouro. Meu irmão acreditou por um segundo. Foi bom." },
		{ "Você sabe contar até cem? Eu sei. Já contei as luzes da rua duas vezes." },
	},
	menina = {
		{ "Eu ajudo a mamãe a carregar o que tem. Mas o que tem é pouco, então eu carrego o ar.", "Tenho medo do escuro. Mas agora as luzes se apagam, e eu tenho medo do claro também." },
		{ "Você já viu um rio? Mamãe diz que existia um aqui perto. Eu nunca conheci." },
		{ "Dou nome aos pássaros que passam. Este se chamava Aurora. Já foi embora.", "Meu irmão me ensinou a assobiar. O som é fininho e não gasta fôlego." },
		{ "Eu colecionava conchas. Agora coleciono silêncios." },
	},
	crianca = {
		{ "Meu pé está descalço porque a bota era do meu irmão. Aí ele partiu, e a bota foi com ele.", "Eu não choro mais. Tem que guardar a água por dentro." },
		{ "Quer ver minha pedra favorita? É igual a todas, mas é minha." },
		{ "Perguntei ao frade onde ficam os mortos. Ele disse que lá em cima. Eu olhei, só vi nuvem.", "Tenho um segredo: já bebi a água da fonte quando ninguém estava olhando." },
		{ "Se eu pudesse pedir um desejo, pediria um dia comprido. Mas cheio." },
	},
	-- ----- elenco ampliado -----
	acendedor = {
		{ "Subo a vara para uma chama que não é minha. Mas fico feliz quando acende.", "Prefiro lampiões que ardem baixo. Duram mais, e a gente fica com a ilusão de ter mais." },
		{ "Cada poste que acendo é uma pequena vitória contra a noite. Há quem nem perceba." },
		{ "O óleo é contado. A paciência também." },
	},
	medico_peste = {
		{ "Cuido dos doentes mesmo sabendo que não há cura. Cuidar também é remédio, dizem.", "O bico da máscara guarda ervas. As ervas já não têm cheiro, mas o hábito tem." },
		{ "Os doentes preferem que eu fique longe. Eu entendo, e fico perto assim mesmo." },
		{ "Estudei muito para descobrir que o que mais cura é companhia. E companhia eu não tenho para dar a todos." },
	},
	menestrel = {
		{ "Canto sobre o que já foi. Em tempo de fome, a memória é o prato mais barato.", "As cordas desafinam com o frio. Afino-as de novo, devagar, como quem arruma a casa." },
		{ "Tenho uma cantiga nova que fala de um rio. Ainda não decidi se o rio volta no último verso." },
		{ "A música não enche o prato, mas enche o silêncio. E o silêncio aqui cresce rápido." },
	},
	padeiro = {
		{ "Assei três pães hoje. O primeiro foi para as crianças, o segundo para os velhos, o terceiro esqueci de assar. Era o meu.", "O cheiro do forno ainda atrai gente. É tudo o que posso oferecer sem farinha." },
		{ "Se alguém sonhar com pão, que sonhe comigo. Eu tento estar nos sonhos que ainda dão fome." },
		{ "Aprendi com meu pai que pão se parte, não se corta. Parto com cuidado. As migalhas são de todos." },
	},
	soldado = {
		{ "A lança está pesada, mas não largo. Largar é aceitar que acabou.", "Quando havia ameaça, eu dormia mal. Agora que não há, não durmo. Não sei qual é pior." },
		{ "O escudo me protege de flecha, de pedra, de olhar. Do último, nem sempre." },
		{ "Se a vila cair, caio com ela. Não por heroísmo. Por falta de lugar para ir." },
	},
	sentinela = {
		{ "A tocha crepita e conversa comigo. É a única voz que me contradiz.", "Sem a minha chama, este quarteirão fica no escuro. Então não saio daqui." },
		{ "Já vi sombras andarem sozinhas. Aproximo a tocha e elas viram parede." },
		{ "O fogo me aquece o rosto e esfria o resto. Conto com isso." },
	},
	cacador = {
		{ "Passo o dia atrás de rastros que já não existem. Fico bom no que desaparece.", "Já atirei em sombras, em ecos, em vultos de névoa. Nunca acertei. Mas também nunca errei." },
		{ "O arco está esticado há dias. Se afrouxar, acaba. Prefiro aguentar com ele." },
		{ "Quem caça por fome não sente alegria na caça. Sente alívio, quando consegue." },
	},
	peregrino = {
		{ "Caminho porque parado dói mais. A estrada, ao menos, muda de lugar sob os meus pés.", "Disseram-me que esta vila tinha uma fonte que nunca secava. Vi a fonte. Ainda corre, mas é um fio." },
		{ "O cajado já gastou o chão por onde passei. Se alguém seguir meu rastro, vai encontrar buracos." },
		{ "Levo comigo um pouco de cada lugar: um grão de areia, uma folha seca, uma lembrança. Cabem na bolsa." },
	},
	carpinteiro = {
		{ "A madeira que serrei hoje era de uma mesa. Alguém me pediu um caixão em troca. A mesa ouviu tudo.", "Aprendi que prego torto também segura. Só não adianta tentar endireitá-lo." },
		{ "Meu martelo bate mais forte quando penso em outra coisa. Hoje está batendo muito forte." },
		{ "Quem trabalha com madeira conhece o cheiro das coisas que passaram. Cada tábua tem uma história, e quase todas acabam em caixão." },
	},
	bebado = {
		{ "Eu... não estou bêbado. Só estou de pé de um jeito torto.", "A garrafa diz coisas que ninguém diz. Pena que só fala quando está cheia." },
		{ "Hic. Perdão. Foi uma saudade." },
		{ "Se o chão balançar, segure em mim. Se eu cair, cai junto. É menos solitário." },
	},
	copista = {
		{ "Copio uma página por dia. O que copio é esquecido pelos outros, mas eu lembro. É um bom acordo.", "A tinta seca depressa e a mão, devagar. Deve ser porque a tinta tem pressa de ser lida." },
		{ "Cada letra bem-feita é uma pequena promessa de que alguém, algum dia, vai ler." },
		{ "Há livros que sobreviveram a reis, a pestes, a incêndios. Quero ajudar este a sobreviver à fome." },
	},
	oleiro = {
		{ "O barro mais fino vem do fundo do rio seco. Cavo até achar um pouco de umidade e chamo de sorte.", "Faço potes para guardar o que não temos. Já tenho uns dez cheios de nada." },
		{ "O forno acende devagar. Eu também. Só que o forno aquece." },
		{ "Um pote bem feito dura mais que quem o fez. Isso consola e entristece ao mesmo tempo." },
	},
	mensageiro = {
		{ "Levo recados de uma vila para outra. Quase todos dizem a mesma coisa: ainda estamos aqui.", "Já corri com ordens, convites, avisos de morte. Hoje levo só cumprimentos. É um bom dia." },
		{ "Se alguém quiser mandar uma palavra para longe, eu levo. Só não garanto que chegue." },
		{ "O caminho está cheio de pegadas que não voltam. Olho para elas e sigo." },
	},
	vendedora_velas = {
		{ "Vendo luz em pedacinhos. Uma por casa, uma por noite. Quem não tem, empresta ao vizinho.", "A cera acaba e o sebo também. Dizem que logo venderei só a chama, sem o pavio." },
		{ "Tenho uma vela especial para cada medo. Para o escuro, uma comprida. Para a solidão, duas." },
		{ "Se a casa estiver fria, acenda uma vela. Ela aquece mais com os olhos do que com a mão." },
	},
	padeira = {
		{ "Assei hoje o último pão do saco. Parti em pedaços iguais para não haver briga. Houve, mesmo assim.", "A massa levedou devagar, como quem pensa. Acho que ela também sabe." },
		{ "O forno está quente, mas o prato, vazio. Faço o que posso com o que há." },
		{ "Mesmo sem farinha, acordo cedo. O corpo se acostumou à madrugada." },
	},
	herbalista = {
		{ "Reúno ervas que sobraram na beira da estrada. Misturo e chamo de chá. Quem bebe agradece.", "Cada erva tem seu uso, mas aqui todas servem para a mesma coisa: aquecer o corpo e enganar a fome." },
		{ "Já usei pétalas no lugar de remédio. Funcionou quando a pessoa acreditou." },
		{ "O cesto está leve. Mas as ervas, quando cheiram, pesam na memória." },
	},
	lanterneira = {
		{ "Levo a luz que posso. Quem anda comigo não tropeça nem se perde.", "A lanterna balança e as sombras dançam. Já me acostumei com elas. São minhas companhias." },
		{ "Se faltar óleo, usarei sebo. Se faltar sebo, usarei saudade. A luz sempre acha um jeito." },
		{ "Acompanho quem tem medo do escuro. Hoje, quase todos." },
	},
	cantora = {
		{ "Canto baixinho para não acordar a fome. Ela cochila, mas ouve tudo.", "Minha voz já foi mais forte. Agora é um fio, mas fio também costura." },
		{ "Há melodias que só se cantam em jejum. Pena que são as mais bonitas." },
		{ "Se ouvir uma cantiga vinda de lugar nenhum, escute. Talvez seja eu, talvez seja o vento. Tanto faz." },
	},
	crianca_vela = {
		{ "A vela é minha! Eu cuido dela. Ela só pode apagar quando eu dormir.", "Se eu soprar bem de leve, a chama dança. Mas não pode soprar forte, senão ela vai embora." },
		{ "A chama é pequenininha, mas ilumina minha mão toda." },
		{ "Mamãe disse que cada vela é uma estrelinha que desceu para ficar com a gente." },
	},
	crianca_lanterna = {
		{ "Estou levando luz para o meu irmão. Ele ficou em casa com medo.", "A lanterna é pesada, mas eu aguento. Eu sou forte, só não tenho comida." },
		{ "Quando balanço a lanterna, as sombras fazem careta. Eu faço também." },
		{ "Se o escuro vier, eu mostro a lanterna e ele foge. Já testei." },
	},
	crianca_pao = {
		{ "Este pão é meu. Eu ganhei. Mas dou um pedaço a quem tiver mais fome que eu.", "Mastigo devagar para o pão durar. Já mastiguei esta mordida uns vinte minutos." },
		{ "Sabe o cheiro de pão? Eu guardo na lembrança para quando ele acaba." },
		{ "O pão é quentinho. Quentinho é o melhor sabor." },
	},
	crianca_livro = {
		{ "Estou aprendendo a ler! Já sei o meu nome. Quer ver? É um A bem grande e depois o resto.", "O livro cheira a papel velho. Gosto do cheiro. Parece a casa da vovó." },
		{ "As letras são formigas pretas que marcham em fila. Estou aprendendo a contar quantas são." },
		{ "Quando eu crescer, vou escrever um livro. Vai ter uma fonte, um sino e um pão." },
	},
}

-- ===== Fazendas dos quarteiroes (Nordeste, Noroeste, Sudeste, Sudoeste) =====
D.fz_ne_lavrador = {
	{
		"Este trigo nasceu doente. Olhe as folhas: manchas cor de ferrugem, como se alguém tivesse esfregado ferro velho nelas.",
		"Passo a enxada para quebrar a crosta, mas a terra endurece de novo na manhã seguinte. Parece que ela guarda a memória do que lhe falta.",
		"Meu avô dizia que o campo cobra o que se deixa de lhe dar. Eu só queria saber o que foi que deixamos de dar.",
	},
	{
		"As espigas vêm vazias. Debulho uma e só encontro casca, e casca não alimenta nem galinha. Galinha, aliás, já não temos.",
	},
}

D.fz_ne_rezadeira = {
	{
		"Rezo ao lado do poço porque foi dele que veio a última água limpa que esta gente bebeu. Falo com ele como se fosse um santo, e ele me responde com um eco seco.",
		"Dizem que reza não molha a terra. Pode ser. Mas é a única coisa que ainda sai de dentro de mim sem pedir nada em troca.",
	},
	{
		"A cada noite aproximo a vela da boca do poço. Quero ver se a água se envergonha e volta.",
	},
}

D.fz_ne_balde = {
	{
		"Venho aqui todo dia com este balde. Jogo a corda, a corda desce, e o balde volta leve. Leve do mesmo jeito.",
		"Meu pai disse que o fundo do poço virou pedra. Mas eu escuto lá embaixo uma coisa pingando. Será que ele não ouve?",
	},
	{
		"Ontem derramei um pouco de água sem querer. Só um pouquinho. Chorei mais do que a água que perdi.",
	},
}

D.fz_ne_doente = {
	{
		"Deixe-me ficar aqui um pouco. As pernas pesam como se eu carregasse a colheita que não houve.",
		"A febre veio junto com a terra seca. Antes eu suava na lavoura; agora suo parado, e o suor não me alivia em nada.",
	},
	{
		"Se eu me deitar, não levanto mais. Por isso fico sentado, olhando o lampião. Enquanto ele aguentar, eu aguento.",
	},
}

D.fz_nw_lavrador = {
	{
		"Dizem que a praga veio com os corvos. Eu digo que os corvos vieram depois, porque só vão aonde já há o que bicar.",
		"Semeei na lua certa, no dia certo, com a reza certa. Se tudo estava certo, o erro é de quem eu não vejo.",
		"Fico por aqui porque um lavrador que abandona a terra deixa de ser lavrador. Vira só um homem faminto.",
	},
	{
		"O espantalho é mais teimoso do que eu: não saiu do lugar nem uma vez. Invejo isso.",
	},
}

D.fz_nw_camponesa = {
	{
		"Colho o que sobra: repolho murcho, uma folha aqui, uma raiz ali. Chamo isto de horta. O frade chamaria de esmola da terra.",
		"Ferve-se tudo junto. O gosto é de nada, mas o caldo aquece, e aquecer já é alguma coisa.",
	},
	{
		"Quando a terra me der uma cabeça inteira de repolho, levo ao frade para benzer. Depois eu como.",
	},
}

D.fz_nw_viuva = {
	{
		"Meu marido morreu semeando. Caiu no meio da fileira, e dizem que a semente ainda estava na mão dele.",
		"Eu mesma a plantei no mesmo lugar. Não nasceu. Mas é a única coisa nesta terra que carrego com orgulho.",
	},
	{
		"Venho todo fim de tarde. Não é para rezar. É para que ele saiba que alguém ainda passa por aqui.",
	},
}

D.fz_nw_menino = {
	{
		"Estou procurando grãos. Uns dias acho um, outros dias acho dois. Guardo no bolso e conto à noite, como se fosse dinheiro.",
		"Já aprendi que o trigo bom é pesado e o trigo ruim é leve. Quase todo trigo daqui é leve.",
	},
	{
		"Se eu achar dez, faço um pão pequeno para dividir com a minha irmã. Já achei seis.",
	},
}

D.fz_se_lavrador = {
	{
		"Lavrei esta fileira três vezes neste ano. A terra é a mesma, a enxada é a mesma, as mãos são as mesmas. Só a resposta mudou.",
		"Há quem culpe o clima, quem culpe o senhor das terras, quem culpe o diabo. Eu culpo a nossa pressa de colher o que não plantamos direito.",
	},
	{
		"Meu pai sempre guardava uma saca de semente de reserva. Comemos a saca no inverno passado. Ele não perdoaria, mas teria comido também.",
	},
}

D.fz_se_herbalista = {
	{
		"Procuro ervas entre as espigas mortas: camomila, losna, o que nascer. Quando a lavoura morre, as ervas bravas respiram melhor.",
		"É curioso. O que ninguém planta é o que ainda sobrevive. Talvez a gente aprendesse alguma coisa com isso, se tivesse tempo.",
	},
	{
		"A losna amarga na boca e aquieta o ventre. Para a fome ela não serve, mas engana bem.",
	},
}

D.fz_se_pastor = {
	{
		"Fui pastor. Tinha quarenta ovelhas, e o pasto daqui já foi verde. Hoje meu cajado é só um galho que me segura em pé.",
		"Vendi a última ao carniceiro e chorei como por um filho. Depois comi a carne dela e chorei de novo, de gratidão.",
	},
	{
		"Ainda saio ao amanhecer para conduzir o rebanho. O hábito é teimoso. Quem foi embora foi o rebanho.",
	},
}

D.fz_se_menina = {
	{
		"Esta é a Dona Espiga. Ela é de palha, como as de verdade, só que a minha ainda tem cabelo.",
		"Ela me avisa quando a chuva vai chegar. Hoje não avisou nada. Está de mau humor.",
	},
	{
		"Se você achar uma gota de água, me traz? A Dona Espiga quer tomar banho.",
	},
}

D.fz_sw_lavrador = {
	{
		"A espiga que você vê ali tem a cor do osso. Quando passa o vento, ela não balança: estala.",
		"Dizem que mais ao sul ainda chove. Já pensei em ir. Mas um lavrador que anda esquece onde enterrou os seus.",
	},
	{
		"Arar de manhã e rezar de tarde. É disso que se compõe o que me resta de calendário.",
	},
}

D.fz_sw_mae = {
	{
		"Fico olhando o lampião porque é a única coisa por aqui que ainda cumpre o que prometeu: uma luz pequena e teimosa.",
		"Meus filhos dormem com fome e acordam com mais. Eu os distraio contando as faíscas que sobem da chama.",
	},
	{
		"Se a luz apagar, que seja depois que eles dormirem.",
	},
}

D.fz_sw_velho = {
	{
		"Vi esta terra dourada. Vi o trigo na altura do peito e as moças atravessando de mão aberta, tocando as espigas.",
		"Agora é o contrário: as espigas é que tocam o chão. Talvez seja um cumprimento. Talvez seja um adeus.",
	},
	{
		"Lembro o cheiro do primeiro pão da colheita. Já o descrevi tantas vezes que tenho medo de estar inventando.",
	},
}

D.fz_sw_balde = {
	{
		"Hoje fui buscar água na fonte da praça. A fila era grande, e o balde, pesado. No caminho derramei metade e não parei de olhar o chão.",
		"Ainda dá para ver a mancha escura onde caiu. Quando secar, volto lá para ver se nasce alguma coisa.",
	},
	{
		"Se eu derramar menos, a gente bebe mais. Estou treinando a andar devagar.",
	},
}

return D
