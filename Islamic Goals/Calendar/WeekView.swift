//
//  WeekView.swift
//  Islamic Goals
//
//  Created by Mehdi Raza Rajani on 12/11/2019.
//  Copyright © 2019 Matz. All rights reserved.
//

import Foundation
import JZCalendarWeekView
import Toast_Swift
class WeekView: JZBaseWeekView {

    override func registerViewClasses() {
        super.registerViewClasses()

        self.collectionView.register(UINib(nibName: EventCell.className, bundle: nil), forCellWithReuseIdentifier: EventCell.className)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventCell.className, for: indexPath) as? EventCell,
            let event = getCurrentEvent(with: indexPath) as? DefaultEvent {
            cell.configureCell(event: event)
            return cell
        }
        preconditionFailure("EventCell and DefaultEvent should be casted")
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedEvent = getCurrentEvent(with: indexPath) as? DefaultEvent {
            print(selectedEvent.title)
        }
    }
}
