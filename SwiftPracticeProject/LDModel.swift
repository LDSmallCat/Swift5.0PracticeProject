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
struct ComicListModel: Convertible {
    let comics: [ComicModel] = []
    let itemTitle = ""
    let titleIconUrl = ""
    let newTitleIconUrl = ""
}
struct ComicModel: Convertible {
    let name: String = ""
    let subTitle: String = ""
    let cover: String = ""
}
