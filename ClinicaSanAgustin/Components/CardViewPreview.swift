import SwiftUI

struct CardViewRepresentable: UIViewRepresentable {
    let title: String
    let subtitle: String?
    let buttonTitle: String
    let spacing: CGFloat

    func makeUIView(context: Context) -> CardView {
        CardView(title: title, subtitle: subtitle, buttonTitle: buttonTitle, target: nil, action: nil, spacing: spacing)
    }

    func updateUIView(_ uiView: CardView, context: Context) {
        // No dynamic update needed for preview
    }

    private func dummyAction() {}
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 8) {
            CardViewRepresentable(
                title: "Como te sientes el dia de hoy",
                subtitle: "Registra ánimo, craving y sueño.",
                buttonTitle: "Abrir",
                spacing: 24
            )
            .frame(height: 180)
            .padding()
//            CardViewRepresentable(
//                title: "Solo título",
//                subtitle: nil,
//                buttonTitle: "Abrir",
//                spacing: 40
//            )
//            .frame(height: 120)
//            .padding()
        }
        .background(Color(.systemBackground))
        .previewLayout(.sizeThatFits)
    }
}
