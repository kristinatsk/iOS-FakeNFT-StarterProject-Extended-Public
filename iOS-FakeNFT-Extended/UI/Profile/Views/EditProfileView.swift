import SwiftUI

struct EditProfileView: View {
    @State private var name = "Joaquin Phoenix"
    @State private var description = "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям."
    @State private var website = "Joaquin Phoenix.com"
    @State private var isShowingPhotoMenu = false
    @State private var isShowingPhotoLinkAlert = false
    @State private var isLoading = false
    @State private var isShowingExitAlert = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 24) {
                
                HStack {
                    Spacer()
                    
                    Button {
                        isShowingPhotoMenu = true
                    } label: {
                        
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())
                            .foregroundStyle(.gray)
                            .overlay(alignment: .bottomTrailing) {
                                ZStack {
                                    Circle()
                                        .fill(Color(uiColor: .inputBackground))
                                        .frame(width: 24, height: 24)
                                    
                                    Image(systemName: "camera")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 12, height: 10)
                                        .foregroundStyle(Color(uiColor: .closeButton))
                                }
                            }
                    }
                    .confirmationDialog(
                        "Фото профиля",
                        isPresented: $isShowingPhotoMenu
                    ) {
                        Button("Изменить фото") {
                            isShowingPhotoLinkAlert = true
                        }
                        
                        Button("Удалить фото", role: .destructive) {
                            
                        }
                        
                        Button("Отмена", role: .cancel) {
                            
                        }
                    }
                    
                    Spacer()
                    
                    
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Имя")
                        .font(Font(UIFont.headline3))
                    TextField("", text: $name)
                        .padding(.leading, 16)
                        .padding(.vertical, 11)
                        .background(Color(uiColor: .inputBackground))
                        .cornerRadius(12)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Описание")
                        .font(Font(UIFont.headline3))
                    TextEditor(text: $description)
                        .padding(.leading, 16)
                        .padding(.vertical, 11)
                        .scrollContentBackground(.hidden)
                        .background(Color(uiColor: .inputBackground))
                        .cornerRadius(12)
                        .frame(height: 132)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Сайт")
                        .font(Font(UIFont.headline3))
                    TextField("", text: $website)
                        .padding(.leading, 16)
                        .padding(.vertical, 11)
                        .background(Color(uiColor: .inputBackground))
                        .cornerRadius(12)
                }
                
                Spacer()
                
                Button("Сохранить") {
                    dismiss()
                }
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(Color(uiColor: .closeButton))
                .foregroundStyle(Color(uiColor: .systemBackground))
                .cornerRadius(16)
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .alert(
                "Ссылка на фото",
                isPresented: $isShowingPhotoLinkAlert
            ) {
                TextField("http://www.example.com", text: .constant(""))
                
                Button("Отмена", role: .cancel) {
                    
                }
                
                Button("Сохранить") {
                    
                }
            }
            
            .alert(
                "Уверены, \nчто хотите выйти?",
                isPresented: $isShowingExitAlert
            ) {
                Button("Остаться", role: .cancel) {
                    
                }
                
                Button("Выйти") {
                    
                }
            }
            
            if isLoading {
                Color(uiColor: .segmentActive)
                    .opacity(0.5)
                    .ignoresSafeArea()
                
                ProgressView()
            }
        }
    }
}

#Preview {
    EditProfileView()
}
