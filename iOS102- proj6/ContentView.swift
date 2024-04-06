//
//  ContentView.swift
//  iOS102- proj6
//
//  Created by Anbu Damodaran on 4/5/24.
//

import SwiftUI
import Firebase

struct Translation: Identifiable {
    let id = UUID()
    let originalText: String
    let translatedText: String
}

class TranslationHistoryViewModel: ObservableObject {
    @Published var translations: [Translation] = []
    
    func addTranslation(original: String, translated: String) {
        translations.append(Translation(originalText: original, translatedText: translated))
    }
    
    func clearHistory() {
        translations = []
    }
}

struct ContentView: View {
    @State private var inputText = ""
    @State private var translatedText = ""
    @StateObject private var translationHistoryViewModel = TranslationHistoryViewModel()
    @State private var showHistory = false
    private let db = Firestore.firestore()

    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter text", text: $inputText)
                    .padding()
                
                Button("Translate") {
                    translateText()
                }
                .padding()
                
                TextField("Translation", text: $translatedText)
                    .padding()
                    .disabled(true)
                
                ScrollView {
                    ForEach(translationHistoryViewModel.translations) { translation in
                        Text("\(translation.originalText) -> \(translation.translatedText)")
                    }
                }
                
                Button("Clear History") {
                    translationHistoryViewModel.clearHistory()
                }
                .padding()
                
                NavigationLink(destination: PreviousTranslationsView(translations: translationHistoryViewModel.translations)) {
                    Text("View Previous Translations")
                }
            }
            .padding()
            .navigationTitle("TranslationMe")
        }
    }
    
    func translateText() {
        // Simulated translation for demonstration
        let translatedText = "Translated \(inputText)"
        self.translatedText = translatedText
        
        // Save the translation to Firestore
        db.collection("translations").addDocument(data: [
            "originalText": inputText,
            "translatedText": translatedText
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added successfully")
            }
        }
        
        // Update translation history
        translationHistoryViewModel.addTranslation(original: inputText, translated: translatedText)
    }
}

struct PreviousTranslationsView: View {
    var translations: [Translation]
    
    var body: some View {
        List(translations) { translation in
            VStack(alignment: .leading) {
                Text("Original: \(translation.originalText)")
                Text("Translated: \(translation.translatedText)")
            }
        }
        .navigationTitle("Previous Translations")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct TranslationMeApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
