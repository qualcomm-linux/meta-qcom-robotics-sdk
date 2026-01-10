// Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
// SPDX-License-Identifier: BSD-3-Clause
module.exports = {
  extends: ['@commitlint/config-conventional'],
  ignores: [(message) => message.startsWith('Merge ')],
  rules: {
    'subject-case': [0],  // allow both uppercase and lowercase subject lines
    'subject-max-length': [1, 'always', 55], // subject line should be no more than 55 characters
    'body-empty': [2, 'never'], // require non-empty body
    'body-max-line-length': [1, 'always', 100], // body lines should be no more than 100 characters
    "body-leading-blank": [2, "always"], // require a leading blank line in the body
    'body-case': [2, 'always', 'sentence-case'], // body should be in sentence case
    'footer-max-line-length': [1, 'always', 100], // footer lines should be no more than 100 characters
    'type-case': [2, 'always', 'lower-case'], // type should be in lowercase
    "type-enum": [2, "always",
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
  }
};