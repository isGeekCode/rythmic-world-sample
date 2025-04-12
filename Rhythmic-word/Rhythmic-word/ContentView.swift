//
//  ContentView.swift
//  Rhythmic-word
//
//  Created by 방현석 on 4/11/25.
//

import SwiftUI

struct LanguageInfo {
    let meaning: String
    let reading: String
}

struct CardEntity {
    let kanji: String
    let kanjiID: String
    let deckType: DeckType
    let languages: [String: LanguageInfo]
}

enum DeckType {
    case kanji
    case alphabet
}

enum LanguageCode: String {
    case kr = "KR"
    case jp = "JP"
}

struct ContentView: View {
    
    @State private var isFlipped: Bool = false
    @State private var currentIndex: Int = 0
    @State private var currentLanguage: LanguageCode = .kr
    
    let hanjaCards: [CardEntity] = [
        CardEntity(
            kanji: "一",
            kanjiID: "0001",
            deckType: DeckType.kanji,
            languages: [
                "kr": LanguageInfo(meaning: "하나", reading: "일"),
                "jp": LanguageInfo(meaning: "ひと", reading: "いち")
            ]
        ),
        CardEntity(
            kanji: "二",
            kanjiID: "0002",
            deckType: DeckType.kanji,
            languages: [
                "kr": LanguageInfo(meaning: "둘", reading: "이"),
                "jp": LanguageInfo(meaning: "ふた", reading: "に")
            ]
        ),
        CardEntity(
            kanji: "三",
            kanjiID: "0003",
            deckType: DeckType.kanji,
            languages: [
                "kr": LanguageInfo(meaning: "셋", reading: "삼"),
                "jp": LanguageInfo(meaning: "み", reading: "さん")
            ]
        ),
        CardEntity(
            kanji: "四",
            kanjiID: "0004",
            deckType: DeckType.kanji,
            languages: [
                "kr": LanguageInfo(meaning: "넷", reading: "사"),
                "jp": LanguageInfo(meaning: "よ", reading: "し")
            ]
        )
    ]
    
    var body: some View {
        let currentCard = hanjaCards[currentIndex]
        
        ZStack {
            headerView(for: currentCard)
            
            if isFlipped {
                backView(for: currentCard)
            } else {
                frontView(for: currentCard)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clear)
        .contentShape(Rectangle())
        .onTapGesture {
            handleTap()
        }
        .gesture(
            DragGesture()
                .onEnded { handleSwipe($0) }
        )
    }
    
    @ViewBuilder
    private func headerView(for card: CardEntity) -> some View {
        // 카드 상단 정보: 왼쪽에 카드 ID, 오른쪽에 현재 언어(KR/JP)를 표시
        HStack {
            VStack {
                HStack {
                    Text(card.kanjiID)
                        .foregroundColor(.gray)
                        .font(.caption)
                    Spacer()
                }
                .padding([.top, .leading])
                Spacer()
            }

            VStack {
                HStack {
                    Text(currentLanguage.rawValue)
                        .foregroundColor(.gray)
                        .font(.caption)
                }
                .padding([.top, .trailing])
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    private func frontView(for card: CardEntity) -> some View {
        // 카드의 앞면: 한자 글자 표시
        Text(card.kanji)
            .font(.system(size: 200))
            .fontWeight(.bold)
    }
    
    @ViewBuilder
    private func backView(for card: CardEntity) -> some View {
        // 카드의 뒷면: 현재 언어에 따른 의미(뜻)와 발음(음) 표시
        VStack {
            Text(card.languages[currentLanguage.rawValue.lowercased()]?.meaning ?? "")
                .font(.system(size: 60))
                .fontWeight(.medium)
            
            Spacer().frame(height: 40)
            
            Text(card.languages[currentLanguage.rawValue.lowercased()]?.reading ?? "")
                .font(.system(size: 40))
                .foregroundColor(.gray)
        }
    }
    
    private func handleTap() {
        // 화면 탭 시 앞/뒷면 전환
        isFlipped.toggle()
    }

    private func handleSwipe(_ value: DragGesture.Value) {
        // 스와이프 제스처 처리: 좌우 이동으로 카드 넘김, 상하로 언어 전환
        if abs(value.translation.width) > abs(value.translation.height) {
            // horizontal swipe
            if value.translation.width < -50 {
                moveToNextCard()
            } else if value.translation.width > 50 {
                moveToPreviousCard()
            }
        } else {
            // vertical swipe
            if isFlipped {
                toggleLanguage()
            }
        }
    }

    private func moveToNextCard() {
        // 다음 카드로 이동, 상태 초기화
        if currentIndex < hanjaCards.count - 1 {
            currentIndex += 1
            isFlipped = false
        }
    }

    private func moveToPreviousCard() {
        // 이전 카드로 이동, 상태 초기화
        if currentIndex > 0 {
            currentIndex -= 1
            isFlipped = false
        }
    }

    private func toggleLanguage() {
        // 현재 언어(KR/JP) 전환
        currentLanguage = (currentLanguage == .kr) ? .jp : .kr
    }
}

#Preview {
    ContentView()
}
