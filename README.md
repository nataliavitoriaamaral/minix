# Modificação do Microkernel MINIX 3 - Sistemas Operacionais

## Sobre o Projeto
Este projeto apresenta uma aplicação prática dos conceitos de Sistemas Operacionais por meio da exploração e modificação da arquitetura de microkernel do MINIX 3.4.0rc6. O trabalho foi desenvolvido no Instituto de Ciência e Tecnologia da Universidade Federal de São Paulo (UNIFESP).

O objetivo principal foi alterar o código-fonte do sistema operacional para implementar três novos algoritmos de escalonamento de processos e comparar seus desempenhos com o escalonador padrão do MINIX sob diferentes cargas de trabalho (CPU-bound e I/O-bound). O relatório técnico completo, com a análise dos resultados e gargalos de hardware, está anexado neste repositório.

## Modificações Implementadas

O projeto foi dividido em diferentes etapas de alteração do kernel e do espaço de usuário:

* **Configuração e Personalização:** Instalação do sistema em ambiente virtualizado e modificação dos banners de boot, login e poweroff.
* **Monitoramento de Processos:** Modificação do Virtual File System (VFS) e Process Manager (PM) no arquivo `exec.c` para registrar e imprimir o caminho absoluto de processos em execução.
* **Algoritmos de Escalonamento:**
  * **First-Come, First-Served (FCFS):** Implementação de um modelo não preemptivo, desativando o quantum e a prioridade dinâmica de múltiplas filas no `proc.c` e `schedule.c`.
  * **Round-Robin (RR):** Implementação de chaveamento circular com quantum dinâmico ($\frac{1000}{n}$ ms), unificando todos os processos de usuário na fila `USER_Q`.
  * **Múltiplas Filas com Quantum Exponencial (MF):** Adaptação do algoritmo MLFQ do MINIX para conceder fatias de tempo de CPU crescentes (em potências de dois) sempre que um processo é rebaixado de fila.

## Resultados e Análise de Desempenho
Os testes revelaram como as trocas de contexto (overhead) afetam cada algoritmo:
* **Cargas CPU-bound:** O algoritmo FCFS e o padrão do MINIX apresentaram a melhor escalabilidade em cenários extremos (200 processos simultâneos), enquanto o Round-Robin sofreu severa degradação devido ao excesso de preempção.
* **Cargas I/O-bound:** O impacto do escalonador perdeu relevância, pois o gargalo dominante tornou-se a resposta do hardware periférico, nivelando os tempos de retorno entre as diferentes abordagens.

## Equipe e Divisão de Tarefas
Este projeto foi desenvolvido em equipe, com as seguintes divisões de trabalho:

* **Natália V. A. do Val:** Implementação do algoritmo FCFS, condução dos testes iniciais, elaboração de seções do relatório e Revisão Geral do Documento.
* **Breno C. R. Nakamura:** Implementação do algoritmo FCFS, testes iniciais e revisão geral.
* **Estevan T. Santos:** Execução do teste final, plotagem dos gráficos de desempenho e elaboração do vídeo do projeto.
* **Gabriel L. Bonavina:** Implementação do Round-Robin e condução dos primeiros testes.
* **Jonas L. Durão:** Implementação do Round-Robin e condução dos primeiros testes.
* **Vinícius A. L. Andrade:** Implementação do algoritmo de Múltiplas Filas com Quantum Exponencial, testes iniciais e revisão geral.

Vídeo demonstrativo das modificações: [YouTube](https://www.youtube.com/watch?v=V0kZwZAHqZE).
