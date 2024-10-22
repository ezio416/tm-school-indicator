// c 2024-10-17
// m 2024-10-21

nvg::Font     font;
const string  pluginColor = "\\$FF0";
const string  pluginIcon  = Icons::University;
Meta::Plugin@ pluginMeta  = Meta::ExecutingPlugin();
const string  pluginTitle = pluginColor + pluginIcon + "\\$G " + pluginMeta.Name;

void Main() {
    font = nvg::LoadFont("DroidSans.ttf");
}

void Render() {
    if (false
        || !S_Enabled
        || (S_HideWithGame && !UI::IsGameUIVisible())
        || (S_HideWithOP && !UI::IsOverlayShown())
        // || !InMap()
    )
        return;

    // const bool sigDev = Meta::IsDeveloperMode();

    bool sigSchool;
#if SIG_SCHOOL
    sigSchool = true;
#else
    sigSchool = false;
#endif

    const bool whitelisted = Meta::IsSchoolModeWhitelisted();
    const bool school = sigSchool && !whitelisted;

    nvg::BeginPath();
    nvg::FontFace(font);
    nvg::FontSize(S_FontSize * (school ? 0.8f : 1.0f));
    nvg::FillColor(school ? S_SchoolColor : S_GoodColor);
    nvg::Text(
        vec2(S_X * DrawExt::GetWidth(), S_Y * DrawExt::GetHeight()),
        school ? Icons::University : Icons::Check
    );
}

void RenderMenu() {
    if (UI::MenuItem(pluginTitle, "", S_Enabled))
        S_Enabled = !S_Enabled;
}

bool InMap(bool allowEditor = false) {
    CTrackMania@ App = cast<CTrackMania@>(GetApp());

    return true
        && App.RootMap !is null
        && cast<CSmArenaClient@>(App.CurrentPlayground) !is null
        && (allowEditor ? true : App.Editor is null)
    ;
}

namespace DrawExt {
    int GetHeight() {
        return Math::Max(1, Draw::GetHeight());
    }

    int GetWidth() {
        return Math::Max(1, Draw::GetWidth());
    }
}