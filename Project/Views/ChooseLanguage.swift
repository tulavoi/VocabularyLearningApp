//
//  ChooseLanguageView.swift
//  Project
//
//  Created by  User on 07.05.2025.
//

import SwiftUI

struct ChooseLanguage: View {
    @EnvironmentObject private var languageModel: LanguageViewModel
    @EnvironmentObject private var courseModel: CourseViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Header()

            ScrollView{
                VStack(alignment: .leading){
                    LanguageList()
                }
            }
        }
    }
    
    // MARK: Header
    @ViewBuilder
    private func Header() -> some View{
        ZStack {
            Color.white
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 4)
            
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title3.bold())
                        .foregroundStyle(Color("SmallTitleColor"))
                }
                
                Spacer()
               
                Text("CHỌN NGÔN NGỮ CHO " + (languageModel.choosingForTerm ? "THUẬT NGỮ" : "ĐỊNH NGHĨA"))
                    .font(.headline.bold())
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 20)
        }
        .frame(height: 60)
    }
    
    // MARK: Language List
    @ViewBuilder
    private func LanguageList() -> some View {
        Text("CÁC NGÔN NGỮ DÙNG NHIỀU")
            .font(.footnote)
            .foregroundColor(Color("SmallTitleColor"))
            .padding(.top)
            .padding(.horizontal)
        
        ForEach(languageModel.languages, id: \.self) { language in
            HStack{
                Button {
                    languageModel.choosingForTerm
                        ? (courseModel.termLanguage = language)
                        : (courseModel.definitionLanguage = language)

                    dismiss()
                } label: {
                    HStack {
                        Text(language.name?.uppercased() ?? "ERROR")
                            .font(.title2)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer()

                        let isSelected = languageModel.choosingForTerm
                            ? language == courseModel.termLanguage
                            : language == courseModel.definitionLanguage

                        if isSelected {
                            Image(systemName: "checkmark")
                                .font(.title3.bold())
                                .foregroundStyle(Color("BlueColor"))
                        }
                    }
                    .padding()

                }
            }
        }
    }
}

struct ChooseLanguageView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseLanguage()
            .environmentObject(LanguageViewModel(context: PersistenceController.shared.container.viewContext))
            .environmentObject(CourseViewModel())
    }
}
