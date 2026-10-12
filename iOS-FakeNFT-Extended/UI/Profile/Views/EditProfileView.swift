import SwiftUI

struct EditProfileView: View {
    @State private var name: String
    @State private var description: String
    @State private var website: String
    @State private var isShowingPhotoMenu = false
    @State private var isShowingPhotoLinkAlert = false
    @State private var isShowingExitAlert = false
    @State private var avatar: String
    @State private var avatarDraft: String
    @Environment(\.dismiss) private var dismiss
    var viewModel: ProfileViewModel
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        _name = State(initialValue: viewModel.name)
        _description = State(initialValue: viewModel.description)
        _website = State(initialValue: viewModel.website)
        _avatar = State(initialValue: viewModel.avatar)
        _avatarDraft = State(initialValue: viewModel.avatar)
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 24) {
                
                HStack {
                    Spacer()
                    
                    Button {
                        isShowingPhotoMenu = true
                    } label: {
                        Group {
                            if let avatarURL = URL(string: avatar), !avatar.isEmpty {
                                AsyncImage(url: avatarURL) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .foregroundStyle(.gray)
                                }
                                .frame(width: 70, height: 70)
                                .clipShape(Circle())
                            } else {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .frame(width: 70, height: 70)
                                    .foregroundStyle(.gray)
                            }
                        }
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
                            avatarDraft = avatar
                            isShowingPhotoLinkAlert = true
                        }
                        
                        Button("Удалить фото", role: .destructive) {
                            avatar = ""
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
                    Task {
                        await viewModel.updateProfile(
                            name: name,
                            description: description,
                            website: website,
                            avatar: avatar
                        )
                        
                        if viewModel.errorMessage == nil {
                            dismiss()
                        }
                    }
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
                TextField("http://www.example.com", text: $avatarDraft)
                
                Button("Отмена", role: .cancel) {
                    
                }
                
                Button("Сохранить") {
                    avatar = avatarDraft
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
            
            if viewModel.isLoading {
                Color(uiColor: .segmentActive)
                    .opacity(0.5)
                    .ignoresSafeArea()
                
                ProgressView()
            }
        }
    }
}

