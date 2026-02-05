// Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
// SPDX-License-Identifier: BSD-3-Clause
module.exports = {
  extends: ['@commitlint/config-conventional'],
  plugins: [
    {
      rules: {
        'no-change-id': (parsed) => {
          const changeId = 'Change-Id:';
          // footer might be null
          if (parsed.footer && parsed.footer.includes(changeId)) {
            return [false, `commit footer must not contain "${changeId}"`];
          }
          return [true, ''];
        }
      }
    }
  ],
  ignores: [(message) => message.startsWith('Merge ')],
  rules: {
    // Overrides and stricter rules based on best practices
    'subject-case': [0],  // allow both uppercase and lowercase subject lines
    'subject-max-length': [2, 'always', 55], // ERROR on subject line > 55 chars
    'body-empty': [2, 'never'], // require non-empty body
    'body-max-line-length': [2, 'always', 100], // ERROR on body lines > 100 chars
    'body-leading-blank': [2, 'always'], // require a leading blank line in the body
    'body-case': [0], // relax sentence-case for body to allow for code blocks, etc.
    'footer-leading-blank': [2, 'always'], // require a leading blank line before footer
    'footer-max-line-length': [2, 'always', 100], // ERROR on footer lines > 100 chars
    'type-case': [2, 'always', 'lower-case'], // type should be in lowercase
    'type-enum': [2, "always",
        [
            "build",
            "chore",
            "ci",
            "docs",
            "feat",
            "fix",
            "perf",
            "refactor",
            "revert",
            "style",
            "test",
            "release",
        ]
    ],
    // Custom rules from plugin
    'no-change-id': [2, 'always'],
  }
};
