import SwiftUI

struct TermsButton: View {
    @State private var showingSheet = false
    
    var body: some View {
        Button(action: {
            showingSheet.toggle()
        }) {
            Image(systemName: "info.circle")
                .font(.title2)
                .foregroundColor(Color.accentColor)
        }
        .sheet(isPresented: $showingSheet) {
            TermsSheetView()
        }
    }
}

struct TermsSheetView: View {
    @Environment(\.dismiss) var dismiss
    
    // Estados para controlar a expansão dos DisclosureGroups
    @State private var toggleStates = ToggleStates()
    @State private var termsExpanded: Bool = true
    @State private var privacyExpanded: Bool = true
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    VStack {
                        Image("DesignTrack") // Substitua pelo nome da sua imagem
                            .resizable()
                            .scaledToFill()
                        Text("""
                        Você tem cada peça do seu projeto na palma da sua mão.

                        Desenvolvido por Gustavo Souza, Henrique Leal, Joaquín Julcamoro, Patrícia Milet com o objetivo de ajudar os designers a se organizarem em meio a projetos simultâneos.
                        """)
                        .multilineTextAlignment(.center)
                        .bold()
                        .padding(.bottom, 10)
                    }
                    
                    // DisclosureGroup para os Termos de Uso
                    DisclosureGroup("Termos de Uso", isExpanded: $termsExpanded) {
                        Text("""
                        Bem-vindo ao Design Track! Antes de usar nosso serviço, leia atentamente os seguintes Termos de Uso.

                        1. Aceitação dos Termos
                        Ao acessar ou utilizar o aplicativo, você concorda em cumprir e estar vinculado a estes Termos. Caso não concorde, não utilize o aplicativo.

                        2. Descrição do Serviço
                        O Design Track permite que você crie e registre projetos, armazenando as informações diretamente no seu dispositivo móvel. Para mais informações, leia a nossa Política de Privacidade.

                        3. Licença de Uso
                        Concedemos a você uma licença limitada, não exclusiva e intransferível para utilizar o Design Track de acordo com os Termos de Uso, para uso pessoal e não comercial.

                        4. Propriedade Intelectual
                        Todos os direitos sobre o Design Track, incluindo propriedade intelectual, pertencem a nós ou aos nossos licenciadores. Você não pode reproduzir ou modificar qualquer parte do aplicativo sem nossa permissão.

                        5. Restrições de Uso
                        Você concorda em não:
                            • Modificar, descompilar ou tentar extrair o código-fonte do aplicativo.
                            • Utilizar o serviço para fins ilegais ou não autorizados.
                            • Distribuir ou reproduzir qualquer parte do serviço sem nossa autorização.
                            • Interferir na segurança ou funcionamento do aplicativo.

                        6. Atualizações e Modificações
                        Reservamo-nos o direito de atualizar ou modificar o Design Track a qualquer momento, incluindo correções de bugs ou melhorias. Você concorda em aceitar essas atualizações conforme exigido.

                        7. Modificação dos Termos
                        Podemos modificar estes Termos de Uso a qualquer momento. As alterações entram em vigor 30 dias após a publicação no aplicativo. É sua responsabilidade revisar os Termos regularmente. Caso continue a usar o serviço após modificações, você concorda com os novos termos.

                        8. Proteção da Privacidade
                        Sua privacidade é importante para nós. Ao usar o Design Track, você concorda com a nossa Política de Privacidade. Para mais informações, leia a nossa Política de Privacidade.

                        9. Limitação de Responsabilidade
                        Na máxima extensão permitida pela lei, não nos responsabilizamos por danos indiretos, incidentais ou consequentes resultantes do uso do Design Track, incluindo perda de dados ou lucros cessantes. Não garantimos a disponibilidade contínua do serviço.

                        10. Lei Aplicável
                        Estes Termos serão regidos pelas leis do Brasil, especificamente do estado de São Paulo. Quaisquer disputas serão resolvidas nos tribunais competentes de São Paulo.

                        11. Contato
                        Para dúvidas, sugestões ou feedback, entre em contato conosco pelo e-mail contact@designtrack.com. Suas opiniões são valiosas para nós!
                        """)
                        .padding(.top, 5)
                    }
                    .padding(.bottom, 10)
                    
                    // DisclosureGroup para a Política de Privacidade
                    DisclosureGroup("Política de Privacidade", isExpanded: $privacyExpanded) {
                        Text("""
                        No Design Track, prezamos pela honestidade, segurança e transparência em relação aos nossos usuários. Esta Política de Privacidade descreve como coletamos, usamos e protegemos suas informações ao utilizar o aplicativo Design Track. Ao usar o Design Track, você concorda com a coleta e uso de informações conforme descrito nesta política. Se você não concorda com os termos, recomendamos que não utilize o aplicativo.

                        1. Informações Coletadas e Armazenadas
                        Durante o uso do aplicativo, você poderá registrar informações relacionadas aos seus projetos. Estes dados ficam armazenados de maneira segura no seu dispositivo móvel. Opcionalmente, você pode vincular imagens aos registros de projetos realizados no app. Essas fotos são armazenadas localmente no seu telefone, dentro do armazenamento do nosso aplicativo.

                        2. Como Utilizamos suas Informações
                        As informações coletadas são utilizadas exclusivamente para permitir o funcionamento do aplicativo e para melhorar sua experiência de uso. Não fazemos uso das informações de forma que envolva a coleta ou o compartilhamento com terceiros.

                        4. Modificações na Política de Privacidade
                        Reservamo-nos o direito de modificar esta Política de Privacidade a qualquer momento. As alterações entrarão em vigor 30 dias após a publicação no aplicativo. É sua responsabilidade revisar regularmente a Política de Privacidade para estar ciente de quaisquer modificações. Ao continuar a acessar ou usar o Design Track após a publicação das alterações, você concorda em ficar vinculado aos termos revisados. Caso não concorde com a nova política, deverá parar de usar o aplicativo.

                        5. Contato
                        Se você tiver dúvidas sobre esta Política de Privacidade ou precisar de mais informações, entre em contato conosco por meio de henrique.leal135@gmail.com ou outro meio de contato.
                        """)
                        .padding(.top, 5)
                    }
                }
                .padding()
            }
            .navigationBarItems(trailing: Button("Fechar") {
                dismiss()
            })
        }
    }
}

// Estrutura para controlar os estados dos toggles (se necessário)
struct ToggleStates {
    var oneIsOn: Bool = false
    var twoIsOn: Bool = true
}

// Preview para visualização no Canvas
struct TermsButton_Previews: PreviewProvider {
    static var previews: some View {
        TermsSheetView()
    }
}
