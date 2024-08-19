#!/bin/bash

# Source: laedit at https://gist.github.com/matthewjberger/7dd7e079f282f8138a9dc3b045ebefa0?permalink_comment_id=5104708#gistcomment-5104708
function nerd-fonts() {
    declare -a fonts=(
        BitstreamVeraSansMono
        CodeNewRoman
        DroidSansMono
        FiraCode
        FiraMono
        Go-Mono
        Hack
        Hermit
        JetBrainsMono
        Meslo
        Noto
        Overpass
        ProggyClean
        RobotoMono
        SourceCodePro
        SpaceMono
        Ubuntu
        UbuntuMono
    )

    fonts_dir="${HOME}/.local/share/fonts"

    if [[ ! -d "$fonts_dir" ]]; then
        mkdir -p "$fonts_dir"
    fi

    for font in "${fonts[@]}"; do
        zip_file="${font}.zip"
        download_url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${zip_file}"
        echo "Downloading $download_url"
        wget "$download_url"
        yes "n" | unzip "$zip_file" -d "$fonts_dir"
        rm "$zip_file"
    done

    find "$fonts_dir" -name '*Windows Compatible*' -delete

    fc-cache -fv
}
