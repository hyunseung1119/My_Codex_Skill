# GIT COMMANDS

## 1) 새 레포 생성 후 최초 푸시

```bash
echo "# My_Codex_Skill" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/hyunseung1119/My_Codex_Skill.git
git push -u origin main
```

## 2) 기존 로컬 레포를 새 원격으로 푸시

```bash
git remote add origin https://github.com/hyunseung1119/My_Codex_Skill.git
git branch -M main
git push -u origin main
```

## 3) 원격 확인

```bash
git remote -v
```

## 4) 기본 upstream 확인

```bash
git status -sb
git branch -vv
```

## 5) 기본 upstream 변경

### main을 codex/main으로 지정

```bash
git branch --set-upstream-to=codex/main main
```

### main을 origin/main으로 되돌리기

```bash
git branch --set-upstream-to=origin/main main
```

## 6) 원격 이름을 분리해 안전하게 운영

```bash
git remote add codex https://github.com/hyunseung1119/My_Codex_Skill.git
git push -u codex main
```
