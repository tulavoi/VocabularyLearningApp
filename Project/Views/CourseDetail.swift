//
//  CourseDetail.swift
//  Project
//
//  Created by  User on 12.05.2025.
//

import SwiftUI

struct CourseDetail: View {
    @EnvironmentObject private var courseModel: CourseViewModel
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var showConfirmDelete: Bool = false
    
    var body: some View {
        VStack {
            header()
            
            Divider()
            
            // Flashcard Content
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(radius: 5)
                    .padding(.horizontal)

                VStack {
                    HStack {
                        Button(action: {
                            // Action for sound button
                        }) {
                            Image(systemName: "speaker.wave.2")
                                .font(.title2)
                                .foregroundColor(.gray)
                        }

                        Spacer()

                        Button(action: {
                            // Action for starred button
                        }) {
                            Image(systemName: "star")
                                .font(.title2)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal, 40)

                    Spacer()

                    Text("ハンカチ")
                        .font(.title)
                        .padding(.bottom, 50)
                    
                    Spacer()
                }
                .padding(.vertical, 30)
            }
            .padding(.vertical, 15)
            .padding(.horizontal, 10)

            Spacer()

            // Bottom Controls
            HStack {
                Button(action: {
                    // Action for rewind button
                }) {
                    Image(systemName: "arrow.uturn.backward")
                        .font(.title2)
                        .foregroundColor(.primary)
                }

                Spacer()

                Button(action: {
                    // Action for play/forward button
                }) {
                    Image(systemName: "play.fill")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 10)
        }
        .background(Color("AddCourseBackground").ignoresSafeArea())
        
// Delete Course Button
//            Button(action: {
//                showConfirmDelete = true
//            }, label: {
//                Image(systemName: "trash")
//                    .font(.title3.bold())
//                    .foregroundStyle(.red)
//            })
//        }
//        .alert(isPresented: $showConfirmDelete) {
//            Alert(
//                title: Text("Xác nhận xoá"),
//                message: Text("Bạn có chắc muốn xoá học phần này không?"),
//                primaryButton: .destructive(Text("Xoá")) {
//                    if courseModel.deleteCourse(context: viewContext, course: courseModel.selectedCourse!) {
//                        dismiss()
//                    }
//                },
//                secondaryButton: .cancel(Text("Huỷ"))
//            )
//        }
        
    }
    
    // MARK: Header
    @ViewBuilder
    private func header() -> some View{
        HStack {
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "xmark")
                    .font(.title2.bold())
                    .foregroundStyle(Color("SmallTitleColor"))
            }

            Spacer()

            Text(courseModel.selectedCourse?.title ?? "Course detail")
                .font(.title3.bold())
                .foregroundColor(Color("SecondaryText"))

            Spacer()

            Button(action: {
                // Action for settings button
            }) {
                Image(systemName: "gearshape")
                    .font(.title2.bold())
                    .foregroundStyle(Color("SmallTitleColor"))
            }
        }
        .padding()
    }
}

struct CourseDetail_Previews: PreviewProvider {
    static var previews: some View {
        CourseDetail()
            .environmentObject(CourseViewModel())
    }
}
