//
//  LDModel.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/8/16.
//  Copyright © 2019 caolaidong. All rights reserved.
//

// MARK: - LLCycleScrollViewModel
struct ExtModel: Convertible {
    let key = ""
    let val = ""
 
}
struct GalleryItemModel: Convertible {
 
    let id: Int = 0
    let linkType: Int = 0
    let cover = ""
    let ext: [ExtModel]?
    let title = ""
    let content = ""
    init() { ext = [] }
}

// MARK: - HomeModel
enum comicType: Int, ConvertibleEnum {
    case none = 0
    case update = 3
    case thematic = 5
    case animation = 9
    case billboard = 11
}
struct ComicListModel: Convertible {
    //homePage
    let comics: [ComicModel] = []
    let itemTitle = ""
    let newTitleIconUrl = ""
    let titleIconUrl = ""
    let comicType: comicType = .none

    //VIP
    let argName = ""
    let canMore = false
}
struct ComicModel: Convertible {
    let name = ""
    let subTitle = ""
    let cover = ""
    let comicId = 0
    let linkType = 0
    let tags = [String]()
    let description = ""
    let short_description = ""
    let author = ""
    
    
}

struct RankModel: Convertible {
    let subTitle = ""
    let title = ""
    let cover = ""
}
