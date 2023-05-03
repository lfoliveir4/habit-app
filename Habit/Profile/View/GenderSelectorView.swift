import SwiftUI

struct GenderSelectorView: View {
    let title: String
    let genders: [Gender]

    @Binding var selectedGender: Gender?

    var body: some View {
        Form {
            Section(header: Text(title)) {
                List(genders, id: \.self) { item in
                    HStack {
                        Text(item.rawValue)
                        Spacer()
                        Image(systemName: "checkmark")
                            .foregroundColor(
                                selectedGender == item ? .orange : .white

                            )
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if !(selectedGender == item) {
                            selectedGender = item
                        }
                    }
                }
            }
        }
    }
}

struct GenderSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        GenderSelectorView(
            title: "Genero",
            genders: Gender.allCases,
            selectedGender: .constant(.male)
        )
    }
}
