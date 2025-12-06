import { Pages } from '../../../base/constants/Pages'
import { ProgrammingLanguage, programmingLanguageIcon } from '../../../base/utils/pl';

class TabReposParams {
  navStack: NavPathStack | null = null
}

interface RepoData {
  url: string;
  name: string;
  desc: string;
  lang: ProgrammingLanguage;
  star: number;
  fork: number;
  view: number;
  lock: boolean;
}

let data: Array<RepoData> = [
  {
    url: 'https://gitcode.com/keygenqt_vz/ohos-gitcode',
    name: 'ohos-gitcode',
    desc: 'Application for HarmonyOS NEXT on ArkTS and ArkUI working with the GitCode REST API.',
    lang: ProgrammingLanguage.arkts,
    star: 33,
    fork: 12,
    view: 155,
    lock: false,
  },
  {
    url: 'https://gitcode.com/keygenqt_vz/aurora-cli',
    name: 'aurora-cli',
    desc: 'Makes life easier for developers on Aurora OS.',
    lang: ProgrammingLanguage.rust,
    star: 3,
    fork: 5,
    view: 246,
    lock: false,
  },
  {
    url: 'https://gitcode.com/keygenqt_vz/skill-patterns-rust',
    name: 'skill-patterns-rs',
    desc: 'Examples classic design patterns.',
    lang: ProgrammingLanguage.rust,
    star: 58,
    fork: 1,
    view: 10,
    lock: false,
  },
  {
    url: 'https://gitcode.com/keygenqt_vz/aurora-rs',
    name: 'aurora-rs',
    desc: 'Rust application for Aurora OS and interaction with the main interfaces.',
    lang: ProgrammingLanguage.rust,
    star: 16,
    fork: 1,
    view: 481,
    lock: false,
  },
  {
    url: 'https://gitcode.com/keygenqt_vz/aurora-cli',
    name: 'keygenqt',
    desc: 'My personal repository.',
    lang: ProgrammingLanguage.unknown,
    star: 0,
    fork: 0,
    view: 0,
    lock: true,
  },
]

@Builder
export function tabRepos(params: TabReposParams) {
  List({ space: 16 }) {
    ForEach(data, (item: RepoData, index: number) => {
      ListItem() {
        Button({ type: ButtonType.Normal, stateEffect: true }) {
          Column({space: 16}) {
            Row({space: 16}) {
              Column() {
                Image(programmingLanguageIcon(item.lang))
                  .fillColor(Color.White)
                  .width(24)
                  .height(24)
              }
              .height(36)
              .width(36)
              .alignItems(HorizontalAlign.Center)
              .justifyContent(FlexAlign.Center)
              .backgroundColor($r('app.color.primary'))
              .borderRadius(36)

              Text(item.name).fontSize(20).fontWeight(FontWeight.Bold)
            }
            .width('100%')
            Text(item.desc).fontSize(16).width('100%')
            Divider().strokeWidth(1).color($r('app.color.primary_light'))
            Row() {
              Row({space: 6}) {
                Row({space: 3}) {
                  Image($r('app.media.icon_star'))
                    .fillColor($r('sys.color.icon'))
                    .width(20)
                    .height(20)
                  Text(item.star.toString()).fontSize(16)
                }
                Row({space: 3}) {
                  Image($r('app.media.icon_graph'))
                    .fillColor($r('sys.color.icon'))
                    .width(20)
                    .height(20)
                  Text(item.fork.toString()).fontSize(16)
                }
                Row({space: 3}) {
                  Image($r('app.media.icon_visibility'))
                    .fillColor($r('sys.color.icon'))
                    .width(20)
                    .height(20)
                  Text(item.view.toString()).fontSize(16)
                }
              }
              Row() {
                Image(item.lock ? $r('app.media.icon_lock') : $r('app.media.icon_unlock'))
                  .fillColor($r('sys.color.icon'))
                  .width(20)
                  .height(20)
              }
            }
            .alignItems(VerticalAlign.Center)
            .justifyContent(FlexAlign.SpaceBetween)
            .width('100%')
          }
          .width('100%')
        }
        .width("100%")
        .padding(24)
        .margin({ top: index ? 0 : 16, bottom: data.length - 1 == index ? 76 : 0 })
        .backgroundColor($r('app.color.primary_light'))
        .border({ width: 0.5, color: $r('app.color.primary') })
        .borderRadius($r('app.float.card_radius'))
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          params.navStack?.pushPath({ name: Pages.repo, param: JSON.stringify({ title: "Repo #" + index }) });
        })
      }
    }, (item: number) => item.toString())
  }.padding({ right: 16, left: 16 }).width("100%")
}