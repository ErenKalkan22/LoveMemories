import SwiftUI
import PhotosUI

struct EditMemoryView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var memory: Memory
    var onSave: (Memory) -> Void
    
    @State private var title: String
    @State private var description: String
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented = false
    @State private var selectedDate: Date
    @State private var selectedCategory: MemoryCategory
    
    init(memory: Binding<Memory>, onSave: @escaping (Memory) -> Void) {
        _memory = memory
        self.onSave = onSave
        _title = State(initialValue: memory.wrappedValue.title)
        _description = State(initialValue: memory.wrappedValue.description)
        _selectedDate = State(initialValue: memory.wrappedValue.date)
        _selectedCategory = State(initialValue: memory.wrappedValue.category)
        if let path = memory.wrappedValue.imagePath, let uiImage = UIImage(contentsOfFile: path) {
            _selectedImage = State(initialValue: uiImage)
        } else {
            _selectedImage = State(initialValue: nil)
        }
    }
    
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
                                    .foregroundColor(category.color)
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
            .navigationTitle("Anıyı Düzenle")
            .navigationBarItems(
                leading: Button("İptal") {
                    dismiss()
                },
                trailing: Button("Kaydet") {
                    saveChanges()
                }
                .disabled(title.isEmpty)
            )
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(image: $selectedImage)
            }
        }
    }
    
    private func saveChanges() {
        var imagePath = memory.imagePath
        if let image = selectedImage {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileName = UUID().uuidString + ".jpg"
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                try? imageData.write(to: fileURL)
                imagePath = fileURL.path
            }
        }
        let updatedMemory = Memory(
            id: memory.id,
            title: title,
            description: description,
            imagePath: imagePath,
            date: selectedDate,
            category: selectedCategory
        )
        onSave(updatedMemory)
        dismiss()
    }
} 