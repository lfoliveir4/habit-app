import SwiftUI
import Combine

struct HabitCardView: View {
    let isChartRoute: Bool
    let viewModel: HabitCardViewModel

    @State private var action = false

    @ViewBuilder
    var destinationLink: some View {
        if isChartRoute {
            viewModel.chartView()
        } else {
            viewModel.habitDetailView()
        }
    }

    var body: some View {
        ZStack (alignment: .trailing) {
            NavigationLink(
                destination: destinationLink,
                isActive: self.$action,
                label: {
                    EmptyView()
                }
            )

            Button(
                action: {
                    self.action = true
                }, label: {
                    HStack {
                        ImageView(url: viewModel.icon)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 32, height: 32)
                            .clipped()
                        
                        Spacer()

                        HStack (alignment: .top) {

                            Spacer()

                            VStack (alignment: .leading, spacing: 4) {
                                Text(viewModel.name).foregroundColor(Color.orange)

                                Text(viewModel.label).foregroundColor(Color("textColor"))

                                Text(viewModel.date).foregroundColor(Color("textColor"))
                            }.frame(maxWidth: 400, alignment: .leading)

                            Spacer()

                            VStack (alignment: .leading, spacing: 4) {
                                Text("Registrado")
                                    .foregroundColor(Color.orange)
                                    .bold()
                                    .multilineTextAlignment(.leading)

                                Text(viewModel.value)
                                    .foregroundColor(Color("textColor"))
                                    .bold()
                                    .multilineTextAlignment(.leading)
                            }

                            Spacer()
                        }
                    }
                    .padding()
                    .cornerRadius(4.0)
                })

                Rectangle().frame(width: 8).foregroundColor(viewModel.state)
        }.background(
            RoundedRectangle(cornerRadius: 4.0)
                .stroke(Color.orange, lineWidth: 1.0)

        )
        .padding(.horizontal, 4)
        .padding(.vertical, 8)
    }
}

struct HabitCardView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) {
            NavigationView {
                List {
                    let viewModel = HabitCardViewModel(
                        id: 1,
                        icon: "https://via.placeholder.com/150",
                        date: "01/01/2021 00:00:00",
                        name: "Estudar SwiftUI",
                        label: "horas",
                        value: "2",
                        state: .green,
                        habitPublisher: PassthroughSubject<Bool, Never>()
                    )
                    HabitCardView(isChartRoute: false, viewModel: viewModel)
                    HabitCardView(isChartRoute: false, viewModel: viewModel)
                    HabitCardView(isChartRoute: false, viewModel: viewModel)
                }
                .frame(maxWidth: .infinity)
                .navigationTitle("Teste")
            }
            .previewDevice("iPhone SE (3rd generation)")
            .preferredColorScheme($0)
        }
    }
}
