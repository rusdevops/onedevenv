FROM rusdevops/bootstrap:cpp

RUN apt update
RUN apt -y install git zsh python-dev \
    neovim python-neovim python3-neovim \
    tmux exuberant-ctags valgrind gdb && \
    rm -rf /var/lib/apt/lists/*

ENV TERM xterm-256color

RUN curl -L http://install.ohmyz.sh | sh || true

COPY .zshrc /tmp/
COPY .tmux.conf /tmp/
COPY init.vim /tmp/

RUN useradd -m developer
RUN chown developer /tmp/.tmux.conf
RUN chown developer /tmp/.zshrc
RUN chown developer /tmp/init.vim

USER developer

RUN mkdir $HOME/.zsh
RUN curl -L git.io/antigen > $HOME/.zsh/antigen.zsh
RUN curl -fLo $HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

RUN mv /tmp/.zshrc $HOME/
RUN mkdir -p $HOME/.config/nvim
RUN mv /tmp/init.vim $HOME/.config/nvim/
RUN mv /tmp/.tmux.conf $HOME/

RUN nvim +PlugInstall +qall
RUN mkdir -p $HOME/.nvim/backup
RUN mkdir -p $HOME/.nvim/swap

RUN git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
RUN zsh --rcs $HOME/.zshrc || true

ENTRYPOINT zsh
