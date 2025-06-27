import SwiftUI
import PhotosUI

struct AddMemoryView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var memories: [Memory]
    @State private var title = ""
    @State private var description = ""
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented = false
    @State private var selectedDate = Date()
    @State private var selectedCategory: MemoryCategory = .love
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Anı Detayları")) {
                    TextField("Başlık", text: $title)
                    TextEditor(text: $description)
                        .frame(height: 100)
                }
                
                Section(header: Text("Kategori")) {
                    Picker("Kategori", selection: $selectedCategory) {
                        ForEach(MemoryCategory.allCases, id: \.self) { category in
                            HStack {
                                Image(systemName: category.iconName)
                                    .foregroundColor(Color(category.color))
                                Text(category.rawValue)
                            }
                            .tag(category)
                        }
                    }
                }
                
                Section(header: Text("Tarih")) {
                    DatePicker("Tarih Seç", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(.compact)
                }
                
                Section(header: Text("Fotoğraf")) {
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    }
                    
                    Button(action: {
                        isImagePickerPresented = true
                    }) {
                        Text(selectedImage == nil ? "Fotoğraf Seç" : "Fotoğrafı Değiştir")
                    }
                }
            }
            .navigationTitle("Yeni Anı")
            .navigationBarItems(
                leading: Button("İptal") {
                    dismiss()
                },
                trailing: Button("Kaydet") {
                    saveMemory()
                }
                .disabled(title.isEmpty)
            )
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(image: $selectedImage)
            }
        }
    }
    
    private func saveMemory() {
        var imagePath: String?
        
        if let image = selectedImage {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileName = UUID().uuidString + ".jpg"
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                try? imageData.write(to: fileURL)
                imagePath = fileURL.path
            }
        }
        
        let newMemory = Memory(
            title: title,
            description: description,
            imagePath: imagePath,
            date: selectedDate,
            category: selectedCategory
        )
        
        memories.append(newMemory)
        saveMemories(memories)
        dismiss()
    }
} 