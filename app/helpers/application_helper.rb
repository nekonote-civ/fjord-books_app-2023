# frozen_string_literal: true

module ApplicationHelper
  # localeに応じて複数形の表記を変える
  # - 日本語の場合 => 本
  # - 英語の場合 => books
  def i18n_pluralize(word)
    I18n.locale == :ja ? word : word.pluralize
  end

  # localeに応じてエラー件数の表記を変える
  # - 日本語の場合 => 3件のエラー
  # - 英語の場合 => 3 errors
  def i18n_error_count(count)
    I18n.locale == :ja ? "#{count}件の#{t('views.common.error')}" : pluralize(count, t('views.common.error'))
  end

  def format_content(content)
    safe_join(content.split("\n"), tag.br)
  end

  def format_report_url(content)
    sanitize_content = sanitize(content, tags: %w[a br], attributes: %w[href])
    sanitize_content.gsub(Report::REPORTS_REGEXP) { |url| link_to(url, url) }
  end

  def elapsed_datetime(before_datetime, after_datetime)
    diff_in_seconds = before_datetime - after_datetime
    if diff_in_seconds >= 1.year
      years_ago = (diff_in_seconds / 1.year).floor
      "#{years_ago} years ago"
    elsif diff_in_seconds >= 1.month
      months_ago = (diff_in_seconds / 1.month).floor
      "#{months_ago} months ago"
    elsif diff_in_seconds >= 1.day
      days_ago = (diff_in_seconds / 1.day).floor
      "#{days_ago} days ago"
    else
      ''
    end
  end
end
