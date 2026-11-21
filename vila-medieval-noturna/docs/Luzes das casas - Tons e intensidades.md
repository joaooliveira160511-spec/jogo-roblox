---
projeto: Jogos - Gerais
origem: Jogos - Gerais
parte: Roblox
tags: [jogos, roblox, luzes, cores]
---
# Luzes das casas - Tons e intensidades
Índice: Jogos - Gerais

## Conceito
- A luz das casas deve parecer de velas: baixa, quente, entre amarelo e laranja, nunca uma lâmpada amarela. Os lampiões das ruas, em contraste, são fortes.

## Tabela de valores finais
| Fonte | Range | Brightness | Cor | Sombras |
|---|---|---|---|---|
| Janela com luz | 13 | 0,3 | (255,176,84) | não |
| Lanterna de porta | 22 | 0,5 | (255,170,80) | não |
| Lampião de poste | 44 | 1,25 | (255,184,108) | sim |
| Lanterna de barraca | 30 | 0,8 | (255,142,58) | não |
| Vagalume | 8 | 0,1 a 2,3 | (190,255,150) | não |

- Cor do Neon das chamas e lanternas: (255,112,28) (laranja mais escuro, para não virar amarelo sob Bloom).
- Decal "Vela" das janelas: ver Janelas - Brilho de vela quadriculado.

## Regras
- Fontes de luz internas nunca devem exceder Brightness 0,5; acima disso as paredes laranja estouram.
- Acesas e piscantes têm o mesmo brilho-base; só o script muda a intensidade temporariamente.
- Mudanças de cor devem ser aplicadas por passe em todas as PointLights e peças Neon (os Neon das lanternas guardam a cor no próprio material).

## Aplicação em massa (exemplo)
```lua
for _, l in ipairs(workspace.Vila:GetDescendants()) do
	if l:IsA("PointLight") then
		if l.Range >= 40 then l.Color = Color3.fromRGB(255, 184, 108)
		elseif l.Range <= 14 then l.Color = Color3.fromRGB(255, 176, 84); l.Brightness = 0.3 end
	end
end
```

## Exceções e limites
- O script LuzesDaVila usa o brilho que a luz tem no início do jogo; alterar brilhos em Edit antes do Play.

## Relacionados
- Luzes - Sistema de estados
- Iluminação - Configuração final da noite
