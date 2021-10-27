//
//  ZXKitUtil+media.swift
//  ZXKitUtil
//
//  Created by Damon on 2020/7/4.
//  Copyright © 2020 Damon. All rights reserved.
//

import Foundation
import AVFoundation

private var vibrateRepeat = false   //标记是否循环震动
private var audioPlayer: AVAudioPlayer? //音乐播放器

public extension ZXKitUtil {
    
    ///获取指定video的时长， 单位秒
    func getVideoDuration(videoURL: URL) -> Double {
        let asset = AVURLAsset(url: videoURL, options: [AVURLAssetPreferPreciseDurationAndTimingKey: false])
        return Double(asset.duration.value) / Double(asset.duration.timescale)
    }
    
    ///获取指定视频的分辨率，支持本地或者网络地址
    func getVideoSize(videoURL: URL) -> CGSize {
        let asset = AVURLAsset(url: videoURL, options: nil)
        if let track = asset.tracks(withMediaType: AVMediaType.video).first {
            return CGSize(width: abs(track.naturalSize.applying(track.preferredTransform).width), height: abs(track.naturalSize.applying(track.preferredTransform).height))
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
    
    /// 播放音乐
    /// - Parameters:
    ///   - url: 文件地址
    ///   - repeated: 是否重复播放
    ///   - audioSessionCategory: 播放模式 .playback 扬声器播放，.playAndRecord听筒模式
    @discardableResult
    func playMusic(url: URL?, repeated: Bool = false, audioSessionCategory: AVAudioSession.Category = AVAudioSession.Category.playback) -> AVAudioPlayer? {
        guard var musicURL = url else { return nil }
        audioPlayer?.stop()
        
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(audioSessionCategory)
        try? audioSession.setActive(true, options: AVAudioSession.SetActiveOptions.init())
        
        
        if musicURL.absoluteString.hasPrefix("http://") || musicURL.absoluteString.hasPrefix("https://") {
            guard let name = musicURL.path.zx.hashString(hashType: .md5) else { return nil }
            let path = ZXKitUtil.shared.createFileDirectory(in: .caches, directoryName: "music").appendingPathComponent(name, isDirectory: false)
            let audioData = try? Data(contentsOf: musicURL)
            try? audioData?.write(to: path)
            musicURL = path
        }
        
        audioPlayer = try? AVAudioPlayer(contentsOf: musicURL, fileTypeHint: nil)
        if repeated {
            audioPlayer?.numberOfLoops = -1
        } else {
            audioPlayer?.numberOfLoops = 0
        }
        audioPlayer?.play()
        return audioPlayer
    }
    
    ///关闭音乐播放
    func stopMusic() -> Void {
        audioPlayer?.stop()
    }
    
    
    /// 播放音效，静音模式不会播放音效
    /// - Parameters:
    ///   - effectURL: 音效文件地址
    ///   - vibrate: 是否震动
    func playEffect(url: URL?, vibrate: Bool = false) -> Void {
        var soundID = SystemSoundID()
        
        if let effect = url {
            AudioServicesCreateSystemSoundID(effect as CFURL, &soundID)
        } else if vibrate {
            soundID = kSystemSoundID_Vibrate
        }
        if vibrate {
            AudioServicesPlayAlertSoundWithCompletion(soundID, nil)
        } else {
            AudioServicesPlaySystemSoundWithCompletion(soundID, nil)
        }
    }
    
    /// 开始震动
    /// - Parameter repeated: 是否循环震动
    func startVibrate(repeated: Bool = false) -> Void {
        vibrateRepeat = repeated
        if repeated {
            AudioServicesPlaySystemSoundWithCompletion(kSystemSoundID_Vibrate) {
                self.startVibrate(repeated: vibrateRepeat)
            }
        } else {
            AudioServicesPlaySystemSoundWithCompletion(kSystemSoundID_Vibrate) {
                
            }
        }
    }
    
    ///结束震动
    func stopVibrate() -> Void {
        vibrateRepeat = false
        AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate)
    }
}
