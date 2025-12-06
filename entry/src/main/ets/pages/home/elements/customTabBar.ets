class CustomTabBarParams {
  icon: ResourceStr | null = null;
  active: boolean = false;
}

@Builder
export function customTabBar(params: CustomTabBarParams) {
  Button({ type: ButtonType.Circle }) {
    Image(params.icon)
      .fillColor(params.active ? $r('app.color.primary') : $r('app.color.btn_round_icon_fill'))
      .width(24)
      .height(24)
  }.width(40).height(40).backgroundColor($r('app.color.btn_round_background'))
}